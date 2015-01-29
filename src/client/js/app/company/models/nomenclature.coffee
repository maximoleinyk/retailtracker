define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')

  class Nomenclature extends Model

    urlRoot: '/nomenclature'

    defaults: ->
      attributes: []
      barcodes: []

    validators:
      name:
        exists: true
        description: ->
          i18n.get('nameIsRequired')
      article:
        exists: true
        description: ->
          i18n.get('articleIsRequired')
      productGroup:
        exists: true
        description: ->
          i18n.get('productGroupIsRequired')
      uom:
        exists: true
        description: ->
          i18n.get('uomIsRequired')

