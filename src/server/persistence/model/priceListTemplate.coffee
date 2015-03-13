mongoose = require('mongoose')
moment = require('moment')

class PriceListTemplate

  constructor: ->
    mongoose.mtModel 'PriceListTemplate', mongoose.Schema
      name:
        type: String
        required: true
      currency:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Currency'
        $tenant: true
        required: true
      description: String
      created:
        type: Date
        default: moment()
      columns:
        type: [
          {
            id: String
            name: String
            type:
              type: String
            amount: Number
          }
        ]
        required: true
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('PriceListTemplate'))

module.exports = PriceListTemplate
