define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')

  class PriceList extends Model

    urlRoot: '/pricelists'
    defaults:
      items: []

    validators:
      name:
        exists: true
        description: ->
          i18n.get('nameIsRequired')
      template:
        exists: true
        description: ->
          i18n.get('templatePriceListIsRequired')
