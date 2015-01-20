define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  context = require('cs!app/common/context')

  class Company extends Model

    defaults: ->
      owner: context.get('account.owner')?._id
      employees: []
      invitees: []
      currencyCode: 'UAH'
      currencyRate: 1

    loadInvitedCompanyDetails: ->
      @promise('get', '/company/invite/' + @get('key'))
      .then (result) =>
        @set(@parse(result.company))
        @set('hasAccount', result.hasAccount)
        @commit()

    create: ->
      @promise('post', '/company', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    update: ->
      @promise('put', '/company/' + @id, @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    fetch: ->
      @promise('get', '/company/' + @id)
      .then (result) =>
        @set @parse(result)
        @commit()
