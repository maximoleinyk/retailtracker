define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  Model = require('cs!app/company/models/warehouseItem')
  request = require('app/common/request')

  class WarehouseItems extends Collection

    model: Model

    fetch: ->
      request.get('/warehouseitem/all').then (result) =>
        @reset(result, {parse: true})
