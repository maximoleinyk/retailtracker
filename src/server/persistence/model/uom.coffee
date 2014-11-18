mongoose = require('mongoose')

class UomSchema

  constructor: ->
    @schema = mongoose.Schema
      shortName:
        type: String
        required: true
      fullName: String
    return @

  get: (namespace) ->
    mongoose.model('Uom', @schema, namespace('uoms'))

module.exports = UomSchema
