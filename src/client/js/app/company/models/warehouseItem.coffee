define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class WarehouseItem extends Model

    urlRoot: '/warehouseitem'
