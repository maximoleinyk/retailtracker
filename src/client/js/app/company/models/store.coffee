define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')

  class Store extends Model

    urlRoot: '/store'

    validators:
      name:
        exists: true
        description: ->
          i18n.get('nameIsRequired')
      manager:
        exists: true
        description: ->
          i18n.get('managerIsRequired')
      priceList:
        exists: true
        description: ->
          i18n.get('priceListIsRequired')
