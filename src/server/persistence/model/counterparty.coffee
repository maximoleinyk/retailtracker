mongoose = require('mongoose')

class CounterpartySchema

  constructor: ->
    schema = mongoose.Schema # TODO: copy schema from moysklad
      name:
        type: String
        required: true
      code:
        type: String
      phone:
        type: String
      fax:
        type: String
      email:
        type: String
      actualAddress:
        type: String
      description:
        type: String
    mongoose.mtModel('Counterparty', schema)
    @

  get: (namespace) ->
    mongoose.mtModel(namespace('Counterparty'))

module.exports = CounterpartySchema
