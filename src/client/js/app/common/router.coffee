define (require) ->
  'use strict'

  Marionette = require('marionette')
  eventBus = require('app/common/eventBus')

  Marionette.AppRouter.extend

    eventBus: eventBus

    constructor: ->
      Marionette.AppRouter::constructor.apply @, arguments

      @listenTo eventBus, 'router:navigate:silent', (methodName) =>
        controller = Marionette.getOption(this, "controller")
        controller.silent or= {}
        method = controller.silent[methodName]
        throw "Silent route should be mapped to existing method" if not method
        method.call(controller)

      @listenTo eventBus, 'router:navigate', =>
        @navigate.apply(@, arguments)

    initialize: (options) ->
      @options = options

    routes:
      'redirect': -> # do nothing

      '*404': ->
        eventBus.trigger('module:load')

    destroy: ->
      @stopListening(eventBus, 'router:navigate')
      @stopListening(eventBus, 'router:navigate:silent')

    navigateTo: (route, options = {trigger: true}) ->
      eventBus.trigger('router:navigate', route, options)