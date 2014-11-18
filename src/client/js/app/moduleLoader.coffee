define (require) ->
  'use strict'

  http = require('util/http')
  _ = require('underscore')
  context = require('cs!app/common/context')
  Promise = require('rsvp').Promise

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
        if not _.isFunction(module.beforeStart)
          module.beforeStart = (result) ->
            new Promise (resolve) ->
              resolve(result)

        startApp = (authenticated) =>
          start(_.extend(module, {
            root: (@root + module.root).replace('//', '/')
            isAuthenticated: authenticated
          }));

        module.initialize(@getPath()) if _.isFunction(module.initialize)

        i18n = new Promise (resolve, reject) ->
          http.get '/i18n/messages/' + module.bundleName, (err, response) ->
            if err then reject(err) else resolve(response)

        i18n
        .then (messages) ->
          window.RetailTracker.i18n = messages
          new Promise (resolve, reject) ->
            http.get '/user/fetch', (err, result) ->
              if err then reject(err) else resolve(result)

        .then (userDetails) =>
          if url.indexOf('account/login') is 0
            context.unset('redirectUrl')
            window.location.replace(@root + defaultModuleName)
          else
            return module.beforeStart(userDetails, @getPath())

        .then (result) =>
          module.onComplete(result) if _.isFunction(module.onComplete)
          startApp(true)

        .then null, (error) =>
          if error is 'Unauthorized'
            if url.indexOf('account/login') isnt 0
              context.set('redirectUrl', url)
              return window.location.replace(@root + 'account/login')
            else
              context.set('redirectUrl', 'brand')
              startApp(false)
          else if error is 'Unknown context'
            window.location.replace(@root + 'brand')
          else
            # handle real error