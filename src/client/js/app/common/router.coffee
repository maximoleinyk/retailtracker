define (require) ->
  'use strict'

  Marionette = require('marionette')
  Backbone = require('backbone')
  http = require('util/http')
  context = require('cs!app/common/context')

  Marionette.AppRouter.extend

    constructor: ->
      Marionette.AppRouter::constructor.apply @, arguments

      silentRoutes = Marionette.getOption(this, "silentRoutes");

      @listenTo Backbone.history, 'route', ->
        context.set('lastAuthUrl', Backbone.history.fragment)

      @listenTo @eventBus, 'router:navigate:silent', (methodName) =>
        controller = Marionette.getOption(this, "controller")
        controller.silent or= {}
        method = controller.silent[methodName]
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
        lastAuthUrl = context.get('lastAuthUrl')
        context.unset('lastAuthUrl')

        if lastAuthUrl
          window.RetailTracker.loader.loadModule(lastAuthUrl.split('/')[0])
        else
          @eventBus.trigger('404')
