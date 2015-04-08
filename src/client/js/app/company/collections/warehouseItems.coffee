define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  Model = require('cs!app/company/models/warehouseItem')
  request = require('app/common/request')
  _ = require('underscore')

  class WarehouseItems extends Collection

    model: Model

    fetch: ->
      request.get('/warehouseitem/all').then (result) =>
        @reset(result, {parse: true})

    updateRemainingCommodity: (warehouseId) ->
      nomenclatureIds = @pluck('nomenclature._id')
      return if not nomenclatureIds.length
      data = {
        warehouse: warehouseId
        nomenclatures: nomenclatureIds
      }
      @promise('post', '/warehouseitem/commodity/all', data).then (result) =>
        _.each nomenclatureIds, (id) =>
          foundObject = _.find result, (object) =>
            object._id is id
          warehouseItem = @findWhere({ 'nomenclature._id': id })
          warehouseItem.set('remainingCommodity', if foundObject then foundObject.remainingCommodity else 0)
