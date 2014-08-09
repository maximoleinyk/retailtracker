define (require) ->
  'use strict'

  Marionette = require('marionette')
  Layout = require('cs!app/common/view/layout')
  Promise = require('rsvp').Promise
  http = require('util/http')
  Backbone = require('backbone')
  _ = require('underscore')

  App = new Marionette.Application
  Marionette.Renderer.render = (compile, data) ->
    compile data

  (mappings) ->
    run = (Router, Controller, options) ->
      options = _.extend(options, {
        before: (resolve) -> return resolve()
      })

      if document.documentElement.className.indexOf('no-support') > -1
        throw new Error('This application cannot be started in Internet Explorer 7 or below.')

      startApp = (user) ->
        options = _.extend(options, {
          user: user
        })

        App.addInitializer (options) ->
          layout = new Layout(options)
          layout.render();

          new Router({
            controller: new Controller(options)
          });

          if (options.user)
            Backbone.history.start({
              pushState: true,
              root: '/ui/'
            })
        App.start(options)

      cookieEnabled = navigator.cookieEnabled or ('cookie' in document and (document.cookie.length > 0 or (document.cookie = 'test').indexOf.call(document.cookie,
        'test') > -1))
      document.documentElement.className += if cookieEnabled then ' cookies': ' no-cookies'

      testAuthentication = new Promise (resolve, reject) =>
        http.get '/security/test', (err) =>
          return reject(err) if err
          options.before(resolve)

      testAuthentication
      .then ->
        startApp(true)
      .then null, (err) ->
        return startApp(false) if (err.status is 401)

    {
    load: ->
      origin = window.location.origin or window.location.protocol + '//' + window.location.host
      url = window.location.href.replace(origin, '').replace('#', '/').replace(/\/\//g, '/')
      moduleName = 'app/management/main'

      # determine which module we should load
      _.each mappings, (name, route) ->
        if (url.indexOf(route) is 0)
          moduleName = 'app/' + name + '/main'

      # invoke loaded module after successful loading
      require ['cs!' + moduleName], (module) -> module(run)
    }
