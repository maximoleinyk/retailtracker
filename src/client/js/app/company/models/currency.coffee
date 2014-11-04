define (require) ->
  'use strict'

  Backbone = require('backbone')

  Backbone.Model.extend

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
