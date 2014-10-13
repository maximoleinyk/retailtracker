define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/mongoCollection')
  Currency = require('cs!app/brand/models/currency')
  request = require('util/request')

  class Currencies extends MongoCollection

    model: Currency

    fetch: ->
      request.get('/currency/all').then (result) =>
        @reset(result, {parse: true})