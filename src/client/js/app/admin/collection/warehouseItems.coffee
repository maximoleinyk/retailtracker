define (require) ->
  'use strict'

  Backbone = require('backbone')
  WarehouseItem = require('cs!app/admin/model/warehouseItem')

  Backbone.Collection.extend({
    model: WarehouseItem
  })
