define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  Promise = require('rsvp').Promise
  context = require('cs!app/common/context')
  i18n = require('cs!app/common/i18n')

  class Warehouse extends Model

    urlRoot: '/warehouse'

    defaults: ->
      name: i18n.get('newWarehouse')
      assignee: context.get('employee')
