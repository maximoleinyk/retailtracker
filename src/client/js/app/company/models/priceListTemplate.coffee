define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')

  class PriceListTemplate extends Model

    urlRoot: '/pricelisttemplate'

    defaults:
      columns: []

    validators:
      name:
        exists: true
        description: ->
          i18n.get('nameIsRequired')
      currency:
        exists: true
        description: ->
          i18n.get('currencyIsRequired')
