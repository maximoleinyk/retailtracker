define (require) ->
  'use strict'

  ModuleLoader = require('cs!./moduleLoader')
  Marionette = require('marionette')
  Layout = require('cs!app/common/views/layout')
  Backbone = require('backbone')
  l10n = require('cs!app/common/l10n')
  Handlebars = require('handlebars')
  _ = require('underscore')

  App = new Marionette.Application
  Marionette.Renderer.render = (compile, data) ->
    window.RetailTracker.i18n = l10n.getMessages()
    compile(_.extend(data, {
      i18n: l10n.getMessages()
      helpers: _.extend({}, Handlebars.helpers, l10n.getFunctions())
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

  loader.loadModule 'account', (options) ->
    App.start(options)
