define (require) ->
  'use strict'

  Marionette = require('marionette')
  sessionStore = require('util/sessionStore')

  Marionette.Layout.extend

    el: '#app'
    template: require('hbs!./layout')

    regions:
      header: '#header'
      container: '#container'

    appEvents:
      'router:navigate': 'hideHeader'
      'http:401': 'redirectToLogin'
      'open:page': 'openPage'

    initialize: (options) ->
      @options = options

    onRender: ->
      @displayHeader()

    hideHeader: (route) ->
      @header.close() if route is '404'

    displayHeader: ->
      return if not @options.isAuthenticated or Backbone.history.fragment is '404'
      @header.show(new @options.Header(@options)) if @options.Header

    openPage: (view) ->
      @container.show(view)

    redirectToLogin: ->
      sessionStore.add('redirectUrl', Backbone.history.fragment)
      window.location.replace('/page/account/login')
