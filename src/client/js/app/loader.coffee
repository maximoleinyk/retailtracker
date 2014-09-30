define (require) ->
  'use strict'

  Marionette = require('marionette')
  Layout = require('cs!app/common/view/layout')
  http = require('util/http')
  Backbone = require('backbone')
  _ = require('underscore')
  eventBus = require('util/eventBus')
  sessionStore = require('util/sessionStore')

  (mappings) ->
    getPath = () ->
      origin = window.location.origin or window.location.protocol + '//' + window.location.host
      window.location.href.replace(origin, '').replace('#', '/').replace(/\/\//g, '/').replace(/^\/page\/?/, '')

    App = new Marionette.Application
    Marionette.Renderer.render = (compile, data) ->
      compile(_.extend(data, {
        i18n: window.RetailTracker.i18n
      }))

    App.addInitializer (options) ->
      layout = new Layout(options)
      layout.render()

      new options.Router({
        controller: new options.Controller(options)
      })

      Backbone.history.start({
        pushState: true
        root: options.root
      })

    {
    loadModule: (name) ->
      if document.documentElement.className.indexOf('no-support') > -1
        throw new Error('This application cannot be started in this browser.')

      cookieEnabled = navigator.cookieEnabled or ('cookie' in document and (document.cookie.length > 0 or (document.cookie = 'test').indexOf.call(document.cookie,
          'test') > -1))
      document.documentElement.className += if cookieEnabled then ' cookies' else ' no-cookies'

      url = getPath()
      firstModule = 'app/' + name + '/main'

      for route of mappings
        do ->
          if url.indexOf(route) is 0
            firstModule = 'app/' + mappings[route] + '/main'

      require ['cs!' + firstModule], (module) ->
        startApp = (authenticated) ->
          if authenticated
            if url.indexOf('account') is 0
              sessionStore.remove('redirectUrl')
              return window.location.replace('/page/admin')
          else
            if url.indexOf('account') isnt 0
              sessionStore.add('redirectUrl', url)
              return window.location.replace('/page/account/login')

          App.start(_.extend(module, {
            isAuthenticated: authenticated
          }))

        getMessages = new Promise (resolve, reject) ->
          http.get '/i18n/messages/' + module.bundleName, (err, response) ->
            if err then reject(err) else resolve(response)

        getMessages
        .then (messages) ->
          window.RetailTracker.i18n = messages
          new Promise (resolve, reject) ->
            http.get '/user/fetch', (err, result) ->
              if err then reject(err) else resolve(result)
        .then ->
          startApp(true)
        .then null, (err) ->
          if err is 'Unauthorized'
            startApp(false)
          else
            # handle properly this case
    }
