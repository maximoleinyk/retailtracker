define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/mongoCollection')
  Model = require('cs!app/company/models/warehouse')
  request = require('util/request')

  class Warehouse extends MongoCollection

    model: Model

    fetch: ->
      request.get('/warehouse/all').then (result) =>
        @reset(result, {parse: true})