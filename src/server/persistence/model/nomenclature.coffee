mongoose = require('mongoose')

class NomenclatureSchema

  constructor: ->
    @schema = mongoose.Schema
      name:
        type: String
        required: true
      description: String
      article: String
      productGroup:
        type: mongoose.Schema.Types.ObjectId
        ref: 'ProductGroup'
      uom:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Uom'
      attributes: [
        {
          key: String
          value: String
        }
      ]
      barcodes: [
        {
          type: String
          value: String
        }
      ]

    return @

  get: (namespace) ->
    mongoose.model('Nomenclature', @schema, namespace('nomenclatures'))

module.exports = NomenclatureSchema