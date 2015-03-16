define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')

  class PriceListTemplate extends Model

    urlRoot: '/pricelisttemplate'

    defaults: ->
      columns: []
      state: 'DRAFT'

    validators:
      name:
        exists: true
        description: ->
          i18n.get('nameIsRequired')
      currency:
        exists: true
        description: ->
          i18n.get('currencyIsRequired')
      columns:
        minLength: 2
        description: ->
          i18n.get('addAnotherColumn')

    isActivated: ->
      @get('state') is 'ACTIVATED'

    activate: ->
      @save(null, {
        url: '/pricelisttemplate/' + this.id + '/activate'
      })
