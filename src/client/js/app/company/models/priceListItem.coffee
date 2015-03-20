define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')
  _ = require('underscore')

  class PriceListItem extends Model

    urlRoot: '/pricelistitems'

    validators:
      priceList:
        exists: true
        description: ->
          i18n.get('priceListIsRequired')
      nomenclature:
        exists: true
        description: ->
          i18n.get('nomenclatureIsRequired')

    generatePrices: (priceListId) ->
      @promise('POST', '/pricelistitems/generate/prices', _.extend(@toJSON(), {
        priceListId: priceListId
      }))
