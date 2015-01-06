mongoose = require('mongoose')

class CounterpartySchema

  constructor: ->
    @schema = mongoose.Schema # TODO: copy schema from moysklad
      name:
        type: String
        required: true
      address:
        type: String
        required: false
      phone:
        type: String
        required: false
      bankIdentifier:
        type: Number
        required: false
      bankAccountIdentifier:
        type: Number
        required: false
    return @

  get: (namespace) ->
    mongoose.model('Counterparty', @schema, namespace('counterparties'))

module.exports = CounterpartySchema
