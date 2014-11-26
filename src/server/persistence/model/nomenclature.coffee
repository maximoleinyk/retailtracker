mongoose = require('mongoose')

class NomenclatureSchema

  constructor: ->
    @schema = mongoose.Schema
      name:
        type: String
        required: true
      description: String
      article: String
      productGroup: mongoose.Schema.Types.ObjectId
      uom: mongoose.Schema.Types.ObjectId
      attributes: [{
        key: String
        value: String
      }]
      barcodes: [{
        type: String
        value: String
      }]

    return @

  get: (namespace) ->
    mongoose.model('Nomenclature', @schema, namespace('nomenclatures'))

module.exports = NomenclatureSchema
