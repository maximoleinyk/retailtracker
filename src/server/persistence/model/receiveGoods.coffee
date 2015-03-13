mongoose = require('mongoose')
moment = require('moment')

class ReceiveGoods

  constructor: ->
    mongoose.mtModel 'ReceiveGoods', mongoose.Schema
      created:
        type: Date
        required: true
        default: moment().toDate()
      confirmed: Date
      number:
        type: Number
        required: true
        unique: true
      assignee:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Employee'
        $tenant: true
        required: true
      warehouse:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Warehouse'
        $tenant: true
#      warehouseItems: [
#        {
#          type: mongoose.Schema.Types.ObjectId
#          ref: 'WarehouseItem'
#          $tenant: true
#        }
#      ]
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('ReceiveGoods'))

module.exports = ReceiveGoods
