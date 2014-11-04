define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/mongoModel')

  class Company extends MongoModel

    defaults:
      employees: []
      invitees: []
      currencyCode: 'UAH'
      currencyRate: 1

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