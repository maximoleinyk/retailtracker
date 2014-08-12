define (require) ->
  'use strict'

  Marionette = require('marionette')
  Layout = require('cs!app/common/view/layout')
  Promise = require('rsvp').Promise
  http = require('util/http')
  Backbone = require('backbone')
  _ = require('underscore')
  eventBus = require('util/eventBus')
  sessionStore = require('util/sessionStore')

  App = new Marionette.Application
  Marionette.Renderer.render = (compile, data) ->
    compile data

  getPath = ->
    origin = window.location.origin or window.location.protocol + '//' + window.location.host
    window.location.href.replace(origin, '').replace('#', '/').replace(/\/\//g, '/').replace(/^\/page\/?/, '')

  App.addInitializer (options) ->
    layout = new Layout(options)
    layout.render();

    new options.Router({
      controller: new options.Controller(options)
      moduleName: options.moduleName
    });

    url = getPath()

    Backbone.history.start({
      pushState: true,
      root: '/page/',
      silent: not options.isAuthenticated and url isnt 'account/login'
    })
    if not options.isAuthenticated and url isnt 'account/login'
      sessionStore.add('redirectUrl', url.replace(/^\/page\/?/, ''))
      return eventBus.trigger('router:navigate', 'account/login', {trigger:true})

  (mappings) ->

    load = (url, defaultModuleName, callback) ->
      callback or= ->
      moduleName = defaultModuleName
      for route of mappings
        do ->
          name = mappings[route]
          if (url.indexOf(route) is 0)
            moduleName = 'app/' + name + '/main'

      prevModule = sessionStore.get('prevNotFound')
      sessionStore.remove('prevNotFound')

      if moduleName && prevModule isnt moduleName
        require ['cs!' + moduleName], (module) ->
          module(run)
      else
        window.location.replace('/404')

    eventBus.on 'load:module', (url, module) ->
      Backbone.history.stop()
      load(url, module)

    run = (options) ->

      if document.documentElement.className.indexOf('no-support') > -1
        throw new Error('This application cannot be started in Internet Explorer 7 or below.')

      cookieEnabled = navigator.cookieEnabled or ('cookie' in document and (document.cookie.length > 0 or (document.cookie = 'test').indexOf.call(document.cookie,
        'test') > -1))
      document.documentElement.className += if cookieEnabled then ' cookies': ' no-cookies'

      testAuthentication = new Promise (resolve, reject) =>
        http.get '/security/test', (err, result) =>
          if err then reject(err) else resolve(result)

      allPromises = [testAuthentication]

      if options.before
        allPromises.push(options.before())

      Promise.all(allPromises)
      .then ->
        startApp(true)
      .then null, (err) ->
        return startApp(false) if (err.status is 401)

    {
    load: ->
      url = getPath()
      load(url, 'app/management/main')
      startApp = (authenticated) ->
        App.start(_.extend(options, {
          isAuthenticated: authenticated
        }))

    }
