mongoose = require('mongoose')

class UomSchema

  constructor: ->
    @schema = mongoose.Schema
      shortName:
        type: String
        required: true
      fullName: String

    mongoose.mtModel('Uom', @schema)

    return @

  get: (namespace) ->
    mongoose.mtModel(namespace('Uom'))

module.exports = UomSchema
