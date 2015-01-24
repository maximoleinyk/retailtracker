mongoose = require('mongoose')

class WarehouseSchema

  constructor: ->
    mongoose.mtModel 'Warehouse', mongoose.Schema
      name:
        type: String
        required: true
      assignee:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Employee'
        $tenant: true
        required: true
      description: String
      address: String
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Warehouse'))

module.exports = WarehouseSchema
