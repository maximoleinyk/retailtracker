define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/mongoModel')

  class Warehouse extends MongoModel

    create: (callback) ->
      @promise('post', '/warehouse/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    update: (callback) ->
      @promise('put', '/warehouse/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    delete: (callback) ->
      @promise('del', '/warehouse/delete', @toJSON())
      .then ->
        callback(null)
      .then(null, callback)
