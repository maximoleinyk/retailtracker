define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/model')

  class Counterparty extends MongoModel

    fetch: () ->
      @promise('get', '/counterparty/' + @id).then (result) =>
        @set @parse(result)

    create: () ->
      @promise('post', '/counterparty/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    update: () ->
      @promise('put', '/counterparty/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    delete: () ->
      @promise('del', '/counterparty/delete', @toJSON())
