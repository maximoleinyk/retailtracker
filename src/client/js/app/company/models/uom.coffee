define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/model')

  class Uom extends MongoModel

    create: (callback) ->
      @promise('post', '/uom/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    update: (callback) ->
      @promise('put', '/uom/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    delete: (callback) ->
      @promise('del', '/uom/delete', @toJSON())
      .then ->
        callback(null)
      .then(null, callback)
