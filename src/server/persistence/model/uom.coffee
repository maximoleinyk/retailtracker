mongoose = require('mongoose')

class UomSchema

  constructor: ->
    mongoose.mtModel 'Uom', mongoose.Schema
      shortName:
        type: String
        required: true
      fullName: String
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Uom'))

module.exports = UomSchema
