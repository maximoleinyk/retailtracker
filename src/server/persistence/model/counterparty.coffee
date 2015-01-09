mongoose = require('mongoose')

class CounterpartySchema

  constructor: ->
    schema = mongoose.Schema # TODO: copy schema from moysklad
      name:
        type: String
        required: true
      phone:
        type: String
        required: false
      email:
        type: String
        required: false
    mongoose.mtModel('Counterparty', schema)
    @

  get: (namespace) ->
    mongoose.mtModel(namespace('Counterparty'))

module.exports = CounterpartySchema
