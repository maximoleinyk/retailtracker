define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')

  class PriceList extends Model

    urlRoot: '/pricelists'

    defaults: ->
      status: 'DRAFT'

    validators:
      name:
        exists: true
        description: ->
          i18n.get('nameIsRequired')
      currency:
        exists: true
        description: ->
          i18n.get('currencyIsRequired')
      formula:
        exists: true
        description: ->
          i18n.get('formulaIsRequired')

    isActivated: ->
      @get('status') is 'ACTIVATED'

    activate: ->
      @save(null, {
        url: '/pricelists/' + this.id + '/activate'
      })
