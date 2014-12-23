define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/model')

  class Currency extends MongoModel

    defaults:
      rate: 1
      code: 'USD'

    getTemplates: ->
      @promise('get', '/currency/templates')

    create: (callback) ->
      @promise('post', '/currency/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    update: (callback) ->
      @promise('put', '/currency/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    delete: (callback) ->
      @promise('del', '/currency/delete', @toJSON())
      .then ->
        callback(null)
      .then(null, callback)
