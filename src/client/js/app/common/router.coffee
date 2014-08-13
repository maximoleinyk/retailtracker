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
        redirectLink = sessionStore.get('redirectUrl')

        if redirectLink
          sessionStore.remove('redirectUrl')
          window.location.replace('/page' + if not redirectLink or redirectLink is '*' then '' else '/' + redirectLink)
        else
          window.location.replace('/404')
