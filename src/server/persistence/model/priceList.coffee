mongoose = require('mongoose')
moment = require('moment')

class PriceList

  constructor: ->
    mongoose.mtModel 'PriceList', mongoose.Schema
      name:
        type: String
        required: true
      template:
        type: mongoose.Schema.Types.ObjectId
        ref: 'PriceListTemplate'
        $tenant: true
        required: true
      description: String
      state:
        type: String
        default: 'DRAFT' # DRAFT ACTIVATED DELETED
      created:
        type: Date
        default: moment()
      itemsCount: Number
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('PriceList'))

module.exports = PriceList
