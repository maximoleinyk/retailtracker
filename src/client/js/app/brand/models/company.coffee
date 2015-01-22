define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  Promise = require('rsvp').Promise
  context = require('cs!app/common/context')

  class Company extends Model

    urlRoot: '/company'

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

    save: ->
      save = new Promise (resolve, reject) =>
        Model::save.apply(this, @toJSON()).done(resolve).fail(reject)
      save.then (result) =>
        @set @parse(result)
        @commit()

    fetch: ->
      @promise('get', '/company/' + @id)
      .then (result) =>
        @set @parse(result)
        @commit()
