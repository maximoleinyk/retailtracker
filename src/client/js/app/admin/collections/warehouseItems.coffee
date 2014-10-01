define (require) ->
  'use strict'

  Backbone = require('backbone')
  WarehouseItem = require('cs!app/admin/models/warehouseItem')

  Backbone.Collection.extend({
    model: WarehouseItem
  })
