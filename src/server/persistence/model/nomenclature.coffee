mongoose = require('mongoose')

class NomenclatureSchema

  constructor: ->
    mongoose.mtModel 'Nomenclature', mongoose.Schema
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
      manufacturer: String
      description: String
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Nomenclature'))

module.exports = NomenclatureSchema
