define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.Layout.extend

    el: '#app'
    template: require('hbs!./layout')

    regions:
      header: '#header'
      container: '#container'

    appEvents:
      'router:reload': 'displayHeader'
      'http:401': 'redirectToLogin'
      'open:page': 'openPage'

    initialize: (options) ->
      @options = options

    onRender: ->
      return @displayHeader() if @options.isAuthenticated

    hideAll: ->
      @header.close()
      @container.close()

    displayHeader: ->
      return if not @options.Header
      @showHeader(new @options.Header(@options))

    showHeader: (view) ->
      @header.show view

    openPage: (view) ->
      @container.show view

    redirectToLogin: ->
      @eventBus.trigger('loader:module', 'account/login')
