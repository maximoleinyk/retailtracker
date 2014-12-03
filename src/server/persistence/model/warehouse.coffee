mongoose = require('mongoose')

class WarehouseSchema

  constructor: ->
    @schema = mongoose.Schema
      name:
        type: String
        required: true
      address:
        type: String
    return @

  get: (namespace) ->
    mongoose.model('Warehouse', @schema, namespace('warehouses'))

module.exports = WarehouseSchema
