mongoose = require('mongoose')

class PriceListItem

  constructor: ->
    mongoose.mtModel 'PriceListItem', mongoose.Schema {
      nomenclature:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Nomenclature'
        $tenant: true
        required: true
      priceList:
        type: mongoose.Schema.Types.ObjectId
        ref: 'PriceList'
        $tenant: true
        required: true
    }, { strict: false } # in order to persist dynamic ids from the price list template columns
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('PriceListItem'))

module.exports = PriceListItem
