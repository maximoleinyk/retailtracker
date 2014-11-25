define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/mongoModel')

  class Nomenclature extends MongoModel

    fetch: ->
      @promise('get', '/nomenclature/' + @id)
      .then (result) =>
        @set @parse(result)
        @commit()

    create: (callback) ->
      @promise('post', '/nomenclature/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    update: (callback) ->
      @promise('put', '/nomenclature/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .then(null, callback)

    delete: (callback) ->
      @promise('del', '/nomenclature/delete', @toJSON())
      .then ->
        callback(null)
      .then(null, callback)
