define (require) ->
  'use strict'

  ModuleLoader = require('cs!./moduleLoader')
  Marionette = require('marionette')
  Layout = require('cs!app/common/views/layout')
  Backbone = require('backbone')

  App = new Marionette.Application
  Marionette.Renderer.render = (compile, data) ->
    compile(_.extend(data, {
      i18n: window.RetailTracker.i18n
    }))

  App.addInitializer (options) ->
    new Layout(options).render()

    new options.Router({
      controller: new options.Controller(options)
    })

    Backbone.history.start({
      pushState: true
      root: options.root
    })

  loader = new ModuleLoader('/page/', {
    'account': 'account'
    'brand': 'brand'
    'company': 'company'
    'pos': 'pos'
  })

  loader.loadModule 'brand', (options) ->
    App.start(options)
