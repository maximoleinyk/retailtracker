define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  Currency = require('cs!app/company/models/currency')
  request = require('app/common/request')

  class Currencies extends MongoCollection

    model: Currency

    fetch: ->
      request.get('/currency/all').then (result) =>
        @reset(result, {parse: true})