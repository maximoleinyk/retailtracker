mongoose = require('mongoose')
moment = require('moment')

class WarehouseItemSchema

  constructor: ->
    mongoose.mtModel 'WarehouseItem', mongoose.Schema
      created:
        type: Date
        default: moment().toDate()
      nomenclature:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Nomenclature'
        $tenant: true
        required: true
      warehouse:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Warehouse'
        required: true
        $tenant: true
      currency:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Currency'
        required: true
        $tenant: true
      currencyCode:
        type: String
        required: true
      currencyRate:
        type: String
        required: true
      quantity:
        type: Number
        default: 0
      price:
        type: Number
        default: 0
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('WarehouseItem'))

module.exports = WarehouseItemSchema
