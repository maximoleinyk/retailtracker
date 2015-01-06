define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/model')

  class Counterparty extends MongoModel

    fetch: (callback) ->
      @promise('get', '/counterparty/' + @id).then (result) =>
        @reset(result, {parse: true})
      .then(null, callback)

    create: (callback) ->
      @promise('post', '/counterparty/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    update: (callback) ->
      @promise('put', '/counterparty/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    delete: (callback) ->
      @promise('del', '/counterparty/delete', @toJSON())
      .then ->
        callback(null)
      .then(null, callback)
