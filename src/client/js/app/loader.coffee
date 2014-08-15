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
    getPath = ->
      origin = window.location.origin or window.location.protocol + '//' + window.location.host
      window.location.href.replace(origin, '').replace('#', '/').replace(/\/\//g, '/').replace(/^\/page\/?/, '')

    App = new Marionette.Application
    Marionette.Renderer.render = (compile, data) ->
      compile(data)

    App.addInitializer (options) ->
      layout = new Layout(options)
      layout.render()

      new options.Router({
        controller: new options.Controller(options)
      })

      Backbone.history.start({
        pushState: true
        root: '/page/'
      })

    {
    loadModule: ->
      if document.documentElement.className.indexOf('no-support') > -1
        throw new Error('This application cannot be started in this browser.')

      cookieEnabled = navigator.cookieEnabled or ('cookie' in document and (document.cookie.length > 0 or (document.cookie = 'test').indexOf.call(document.cookie,
        'test') > -1))
      document.documentElement.className += if cookieEnabled then ' cookies': ' no-cookies'

      url = getPath()
      firstModule = 'app/admin/main'

      for route of mappings
        do ->
          if url.indexOf(route) is 0
            firstModule = 'app/' + mappings[route] + '/main'

      require ['cs!' + firstModule], (module) ->
        module.beforeStart or= (resolve) ->
          resolve()

        startApp = (authenticated) ->
          if not authenticated and url.indexOf('account') isnt 0
            sessionStore.add('redirectUrl', url or '*')
            return window.location.replace('/page/account/login')

          App.start(_.extend(module, {
            isAuthenticated: authenticated
          }))

        resolve = ->
          startApp(true)

        reject = (err) ->
          if err.status is 401
            startApp(false)
          else
            # handle properly this case

        module.beforeStart(resolve, reject)

    }
