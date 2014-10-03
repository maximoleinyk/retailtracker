define (require) ->
  'use strict'

  http = require('util/http')
  _ = require('underscore')
  eventBus = require('util/eventBus')
  sessionStore = require('util/sessionStore')

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

    loadModule: (defaultModuleName, start) ->
      @isBrowserSupported()
      @isCookies()

      url = @getPath() or @mappings[defaultModuleName]
      firstModule = 'app/' + defaultModuleName + '/main'

      for route of @mappings
        do =>
          if url.indexOf(route) is 0
            firstModule = 'app/' + @mappings[route] + '/main'

      require ['cs!' + firstModule], (module) =>
        startApp = (authenticated) =>
          if authenticated
            if url.indexOf('account') is 0
              sessionStore.remove('redirectUrl')
              return window.location.replace(@root + defaultModuleName)
          else
            if url.indexOf('account') isnt 0
              sessionStore.add('redirectUrl', url)
              return window.location.replace(@root + 'account/login')

          start(_.extend(module, {
            root: (@root + module.root).replace('//', '/')
            isAuthenticated: authenticated
          }));

        i18n = new Promise (resolve, reject) ->
          http.get '/i18n/messages/' + module.bundleName, (err, response) ->
            if err then reject(err) else resolve(response)

        i18n
        .then (messages) ->
          window.RetailTracker.i18n = messages
          new Promise (resolve, reject) ->
            http.get '/user/fetch', (err, result) ->
              if err then reject(err) else resolve(result)
        .then (result) ->
          module?.onUserLoaded(result)
          startApp(true)
        .then null, (err) ->
          if err is 'Unauthorized'
            startApp(false)
          else
            # handle properly this case
