mongoose = require('mongoose')

class CurrencySchema

  constructor: ->
    @schema = mongoose.Schema
      name:
        type: String
        required: true
      code:
        type: String
        required: true
      rate:
        type: Number
        required: true
    return @

  get: (namespace) ->
    mongoose.model('Currency', @schema, namespace('currencies'))

module.exports = CurrencySchema
