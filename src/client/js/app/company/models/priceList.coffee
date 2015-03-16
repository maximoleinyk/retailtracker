define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')

  class PriceList extends Model

    urlRoot: '/pricelists'

    defaults: ->
      items: []
      state: 'DRAFT'

    validators:
      name:
        exists: true
        description: ->
          i18n.get('nameIsRequired')
      template:
        exists: true
        description: ->
          i18n.get('templatePriceListIsRequired')
      items:
        minLength: 1
        description: ->
          i18n.get('itemShouldBeNotEmpty')

    isActivated: ->
      @get('state') is 'ACTIVATED'

    activate: ->
      @save(null, {
        url: '/pricelists/' + this.id + '/activate'
      })

    generatePrices: ->
      @promise('POST', '/pricelists/generate/prices', this.toJSON())
