define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/mongoModel')
  context = require('cs!app/common/context')

  class Company extends MongoModel

    defaults: ->
      owner: context.id
      employees: []
      invitees: []
      currencyCode: 'UAH'
      currencyRate: 1

    enter: ->
      @promise('post', '/company/enter/' + @id)

    loadInvitedCompanyDetails: ->
      @promise('get', '/company/invite/' + @get('key'))
      .then (result) =>
        @set @parse(result)
        @commit()

    create: ->
      @promise('post', '/company/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    update: ->
      @promise('put', '/company/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    fetch: ->
      @promise('get', '/company/' + @id)
      .then (result) =>
        @set @parse(result)
        @commit()