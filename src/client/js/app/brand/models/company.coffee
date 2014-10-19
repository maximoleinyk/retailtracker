define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/mongoModel')

  class Company extends MongoModel

    defaults: {
      invitees: []
    }

    create: (callback) ->
      @request('post', '/company/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    update: (callback) ->
      @request('put', '/company/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    delete: (callback) ->
      @request('del', '/company/delete', @toJSON())
      .then ->
        callback(null)
      .then(null, callback)
