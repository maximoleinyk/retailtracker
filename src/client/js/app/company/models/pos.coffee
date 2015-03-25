define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')

  class Pos extends Model

    urlRoot: '/pos'

    defaults:
      cashiers: []

    validators:
      name:
        exists: true
        description: ->
          i18n.get('nameIsRequired')
      store:
        exists: true
        description: ->
          i18n.get('storeIsRequired')
      cashiers:
        minLength: 1
        description: ->
          i18n.get('addMinimumOneCashier')
