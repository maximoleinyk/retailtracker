define (require) ->
  'use strict'

  Marionette = require('marionette')
  template = require('hbs!./layout')
  LoginPage = require('cs!app/common/view/login')

  Marionette.Layout.extend

    el: '#app'
    template: template

    regions:
      header: '#header'
      container: '#container'

    appEvents:
      'router:reload': 'showNavigation'
      'http:401': 'openLoginPage'
      'open:page': 'openPage'

    initialize: (options) ->
      @options = options

    showNavigation: ->
      @showHeader(new @options.Header(@options))

    onRender: ->
      return @showHeader new @options.Header(@options) if @options.user
      @openLoginPage()

    showHeader: (view) ->
      @header.show view

    openPage: (view) ->
      @container.show view

    openLoginPage: ->
      Backbone.history.stop();
      @header.close()
      @eventBus.trigger 'open:page', new LoginPage(@options)
