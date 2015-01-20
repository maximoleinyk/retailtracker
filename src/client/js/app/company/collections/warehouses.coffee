define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  Model = require('cs!app/company/models/warehouse')
  request = require('app/common/request')

  class Warehouse extends Collection

    model: Model

    fetch: ->
      request.get('/warehouse/all').then (result) =>
        @reset(result, {parse: true})
