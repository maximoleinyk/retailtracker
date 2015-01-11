mongoose = require('mongoose')

class CurrencySchema

  constructor: ->
    mongoose.mtModel 'Currency', mongoose.Schema
      name:
        type: String
        required: true
      code:
        type: String
        required: true
      rate:
        type: Number
        required: true
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Currency'))

module.exports = CurrencySchema
