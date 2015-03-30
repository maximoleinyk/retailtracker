define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')
  context = require('cs!app/common/context')

  class Company extends Model

    urlRoot: '/company'

    validators:
      name:
        exists: true
        description: ->
          i18n.get('nameIsRequired')
      currencyRate:
        exists: true
        description: ->
          i18n.get('currencyRateIsRequired')
      currencyCode:
        exists: true
        description: ->
          i18n.get('currencyCodeIsRequired')

    defaults: ->
      owner: context.get('account.owner')?._id
      employees: []
      invitees: []
      currencyCode: 'UAH'
      currencyRate: 1

    startSession: ->
      @promise('post', '/company/start', @toJSON())

    loadInvitedCompanyDetails: ->
      @promise('get', '/company/invite/' + @get('key'))
      .then (result) =>
        @set @parse(result.company)
        @set('hasAccount', result.hasAccount)
        @commit()
