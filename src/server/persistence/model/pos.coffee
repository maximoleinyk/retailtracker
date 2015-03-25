mongoose = require('mongoose')

class PosSchema

  constructor: ->
    mongoose.mtModel 'Pos', mongoose.Schema
      name:
        type: String
        required: true
      description: String
      store:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Store'
        required: true
        $tenant: true
      cashiers: [
        {
          type: mongoose.Schema.Types.ObjectId
          ref: 'Employee'
          $tenant: true
        }
      ]
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Pos'))

module.exports = PosSchema
