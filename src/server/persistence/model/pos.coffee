mongoose = require('mongoose')

class PosSchema

  constructor: ->
    mongoose.mtModel 'Pos', mongoose.Schema
      name:
        type: String
        required: true
      store:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Store'
        required: true
        $tenant: true
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Pos'))

module.exports = PosSchema
