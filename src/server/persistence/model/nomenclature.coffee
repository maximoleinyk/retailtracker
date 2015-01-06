mongoose = require('mongoose')

class NomenclatureSchema

  constructor: ->
    schema = mongoose.Schema
      name:
        type: String
        required: true
      article: String
      productGroup:
        type: mongoose.Schema.Types.ObjectId
        ref: 'ProductGroup'
        $tenant: true
      uom:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Uom'
        $tenant: true
      attributes: [
        {
          key: String
          value: String
        }
      ]
      barcodes: [
        {
          type:
            type: String
          value: String
        }
      ]
      description: String
    mongoose.mtModel('Nomenclature', schema)
    @

  get: (namespace) ->
    mongoose.mtModel(namespace('Nomenclature'))

module.exports = NomenclatureSchema
