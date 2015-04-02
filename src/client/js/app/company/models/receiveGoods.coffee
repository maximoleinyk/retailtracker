define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  moment = require('moment')
  i18n = require('cs!app/common/i18n')

  class ReceiveGoods extends Model

    urlRoot: '/receivegoods'

    defaults:
      number: 1
      status: 'DRAFT'
      items: []
      created: moment().toDate()

    validators:
      number:
        exists: true
        isNumeric: true
        description: ->
          i18n.get('numberIsRequired')
      assignee:
        exists: true
        description: ->
          i18n.get('assigneeIsRequired')
      warehouse:
        exists: true
        description: ->
          i18n.get('warehouseIsRequired')
      currency:
        exists: true
        description: ->
          i18n.get('currencyIsRequired')
      items:
        minLength: 1
        description: ->
          i18n.get('pleaseAddOneOrMoreProducts')

