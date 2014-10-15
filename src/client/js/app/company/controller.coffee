define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  HomePage = require('cs!./views/home')
  Uom = require('cs!./collections/uoms')
  UomPage = require('cs!./views/uom')
  Currencies = require('cs!./collections/currencies')
  CurrenciesPage = require('cs!./views/currencies')

  Controller.extend

    home: ->
      @openPage(new HomePage())

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
