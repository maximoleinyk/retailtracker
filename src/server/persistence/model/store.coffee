mongoose = require('mongoose')

class StoreSchema

  constructor: ->
    mongoose.mtModel 'Store', mongoose.Schema
      name:
        type: String
        required: true
      warehouse:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Warehouse'
        $tenant: true
      priceList:
        type: mongoose.Schema.Types.ObjectId
        ref: 'PriceList'
        required: true
        $tenant: true
      address: String
      manager:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Employee'
        $tenant: true
        required: true
      description: String
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Store'))

module.exports = StoreSchema
