define (require) ->
  'use strict'

  Marionette = require('marionette')
  Backbone = require('backbone')
  http = require('util/http')
  sessionStore = require('util/sessionStore')

  Marionette.AppRouter.extend

    constructor: ->
      Marionette.AppRouter::constructor.apply @, arguments

      silentRoutes = Marionette.getOption(this, "silentRoutes");

      @listenTo @eventBus, 'router:navigate:silent', (name) =>
        methodName = silentRoutes[name]
        controller = Marionette.getOption(this, "controller")
        method = controller[methodName]
        throw "Silent route should be mapped to existing method" if not method
        method.call(controller)

      @listenTo @eventBus, 'router:navigate', =>
        @navigate.apply(@, arguments)

      @listenTo @eventBus, 'router:reload', =>
        returnUrl = Backbone.history.fragment
        @navigate.call @, 'redirect', {
          trigger: true
          replace: false
        }
        @navigate.call @, returnUrl, {
          trigger: true
          replace: true
        }

    initialize: (options) ->
      @options = options

      @appRoutes['logout'] = 'logout'

    routes:
      'redirect': -> # do nothing

      '*404': ->
        redirectUrl = sessionStore.get('redirectUrl')
        fragment = Backbone.history.fragment

        if redirectUrl or fragment is 'default'
          sessionStore.remove('redirectUrl')
          window.location.replace('/page' + if not redirectUrl or redirectUrl is 'default' then '' else '/' + redirectUrl)
        else
          window.location.replace('/404')
