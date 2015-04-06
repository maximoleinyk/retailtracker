mongoose = require('mongoose')
moment = require('moment')

class PriceList

  constructor: ->
    mongoose.mtModel 'PriceList', mongoose.Schema
      name:
        type: String
        required: true
      formula:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Formula'
        $tenant: true
        required: true
      currency:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Currency'
        $tenant: true
        required: true
      description: String
      status:
        type: String
        default: 'DRAFT' # DRAFT ACTIVATED DELETED
      created:
        type: Date
        default: moment()
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('PriceList'))

module.exports = PriceList
