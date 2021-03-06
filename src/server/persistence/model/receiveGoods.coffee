mongoose = require('mongoose')
moment = require('moment')

class ReceiveGoods

  constructor: ->
    mongoose.mtModel 'ReceiveGoods', mongoose.Schema
      number:
        type: String
        required: true
#        unique: true
      status:
        type: String
        required: true # DRAFT DELETED ENTERED
        default: 'DRAFT'
      created:
        type: Date
        required: true
        default: moment().toDate()
      entered: Date
      currency:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Currency'
        $tenant: true
      currencyCode: String
      currencyRate: String
      assignee:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Employee'
        $tenant: true
        required: true
      warehouse:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Warehouse'
        $tenant: true
      totalQuantity: Number
      totalPrice: Number
      items: [
        {
          nomenclature:
            type: mongoose.Schema.Types.ObjectId
            ref: 'Nomenclature'
            $tenant: true
          quantity: Number
          price: Number
          totalPrice: Number
        }
      ]
      description: String
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('ReceiveGoods'))

module.exports = ReceiveGoods
