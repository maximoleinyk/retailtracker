define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/model')

  class ProductGroup extends MongoModel

    create: (callback) ->
      @promise('post', '/productgroup/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    update: (callback) ->
      @promise('put', '/productgroup/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    delete: (callback) ->
      @promise('del', '/productgroup/delete', @toJSON())
      .then ->
        callback(null)
      .then(null, callback)
