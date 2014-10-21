define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/mongoModel')

  class Company extends MongoModel

    defaults:
      invitees: []
      currencyCode: 'UAH'
      currencyRate: 1

    create: () ->
      @request('post', '/company/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    update: () ->
      @request('put', '/company/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    delete: () ->
      @request('del', '/company/delete', @toJSON())
