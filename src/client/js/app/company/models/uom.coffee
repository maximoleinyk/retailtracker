define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/mongoModel')

  class Uom extends MongoModel

    create: (callback) ->
      @request('post', '/uom/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    update: (callback) ->
      @request('put', '/uom/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    delete: (callback) ->
      @request('del', '/uom/delete', @toJSON())
      .then ->
        callback(null)
      .then(null, callback)
