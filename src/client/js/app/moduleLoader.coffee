define (require) ->
  'use strict'

  http = require('util/http')
  _ = require('underscore')
  context = require('cs!app/common/context')
  Promise = require('rsvp').Promise
  i18n = require('cs!app/common/i18n')
  Marionette = require('marionette')
  Layout = require('cs!app/common/views/layout')
  Backbone = require('backbone')
  Handlebars = require('handlebars')
  cookies = require('cookies')
  request = require('util/request')

  App = new Marionette.Application
  Marionette.Renderer.render = (compile, data) ->
    compile(_.extend(data, {
      i18n: i18n.getMessages()
      helpers: _.extend({}, Handlebars.helpers, i18n.getFunctions())
    }))

  App.addInitializer (options) ->
    new Layout(options).render()

    new options.Router({
      controller: new options.Controller(options)
    })

    Backbone.history.start({
      pushState: true
      root: options.root
    })

  class ModuleLoader

    constructor: (@root, @mappings) ->

    getPath: ->
      location = window.location
      origin = location.origin or location.protocol + '//' + location.host
      location.href.replace(origin, '').replace('#', '/').replace(/\/\//g, '/').replace(new RegExp('^' + @root + '?'),
        '')

    isBrowserSupported: ->
      if document.documentElement.className.indexOf('no-support') > -1
        throw new Error('This application cannot be started in this browser.')

    isCookies: ->
      cookie = document.cookie
      cookieEnabled = navigator.cookieEnabled or ('cookie' in document and (cookie.length > 0 or (cookie = 'test').indexOf.call(cookie,
        'test') > -1))
      document.documentElement.className += if cookieEnabled then ' cookies' else ' no-cookies'

    loadModule: (defaultModuleName) ->
      @isBrowserSupported()
      @isCookies()

      url = @getPath() or @mappings[defaultModuleName]
      firstModule = 'app/' + defaultModuleName + '/main'

      for route of @mappings
        do =>
          if url.indexOf(route) is 0
            firstModule = 'app/' + @mappings[route] + '/main'

      require ['cs!' + firstModule], (module) =>
        if not _.isFunction(module.beforeStart)
          module.beforeStart = (result) ->
            new Promise (resolve) ->
              resolve(result)

        startApp = (authenticated) =>
          App.start(_.extend(module, {
            root: (@root + module.root).replace('//', '/')
            isAuthenticated: authenticated
          }));

        module.initialize(@getPath()) if _.isFunction(module.initialize)

        request.get('/i18n/messages/' + module.bundleName)
        .then (messages) ->
          i18n.init(messages)
          request.get(module.authUrl)

        .then =>
          if url.indexOf('account/login') is 0
            context.unset('lastAuthUrl')
            window.location.replace(@root + defaultModuleName)
          else
            return module.beforeStart(@getPath())

        .then (result) =>
          module.onComplete(result) if _.isFunction(module.onComplete)
          startApp(true)

        .then null, (error) =>
          if error is 'Unauthorized'
            if url.indexOf('account') isnt 0
              context.set('lastAuthUrl', url)
              return window.location.replace(@root + 'account/login')
            else
              context.set('lastAuthUrl', 'brand')
              startApp(false)
          else if error is 'Unknown context'
            window.location.replace(@root + 'brand')
          else
            # handle real error