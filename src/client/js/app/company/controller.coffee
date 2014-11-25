define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  DashboardPage = require('cs!./views/dashboard')
  Uom = require('cs!./collections/uoms')
  UomPage = require('cs!./views/uom')
  Currencies = require('cs!./collections/currencies')
  CurrenciesPage = require('cs!./views/currencies')
  SettingsPage = require('cs!app/brand/views/settings/main')

  Controller.extend

    dashboard: ->
      @openPage(new DashboardPage)

    uom: ->
      collection = new Uom
      collection.fetch()
      .then =>
        @openPage new UomPage({
          collection: collection
        })

    currency: ->
      collection = new Currencies
      collection.fetch()
      .then =>
        @openPage new CurrenciesPage({
          collection: collection
        })

    settings: (view) ->
      @openPage new SettingsPage({
        view: view
      })