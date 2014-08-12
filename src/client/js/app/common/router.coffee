define (require) ->
  'use strict'

  Marionette = require('marionette')
  Backbone = require('backbone')
  http = require('util/http')
  sessionStore = require('util/sessionStore')

  Marionette.AppRouter.extend

    constructor: ->
      Marionette.AppRouter::constructor.apply @, arguments

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
        url = Backbone.history.fragment
        return if url is '404'
#
#        if @options.moduleName is sessionStore.get('module')
#          @eventBus.trigger('router:navigate', '404', {trigger:true})
#        else
        sessionStore.add('prevNotFound', @options.moduleName)
        @eventBus.trigger('load:module', url)
