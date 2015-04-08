define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class WarehouseItem extends Model

    urlRoot: '/warehouseitem'

    getCommodity: (nomenclatureId, warehouseId) ->
      data =
        nomenclature: nomenclatureId
      data.warehouse = warehouseId if warehouseId
      @promise('post', '/warehouseitem/commodity', data).then (result) =>
        @set('remainingCommodity', result.remainingCommodity)
