mongoose = require('mongoose')

class StoreSchema

  constructor: ->
    mongoose.mtModel 'Store', mongoose.Schema
      name:
        type: String
        required: true
      address:
        type: String
      manager:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Employee'
        $tenant: true
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Store'))

module.exports = StoreSchema
