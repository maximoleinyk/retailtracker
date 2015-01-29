define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')

  class Counterparty extends Model

    urlRoot: '/counterparty'

    validators:
      name:
        exists: true
        description: ->
          i18n.get('nameIsRequired')
