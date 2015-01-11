mongoose = require('mongoose')

class WarehouseSchema

  constructor: ->
    mongoose.mtModel 'Warehouse', mongoose.Schema
      name:
        type: String
        required: true
      address:
        type: String
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Warehouse'))

module.exports = WarehouseSchema
