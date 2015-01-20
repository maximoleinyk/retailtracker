define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class Warehouse extends Model

    fetch: ->
      @promise('get', '/warehouse/' + @id).then (result) =>
        @set @parse(result)

    create: (callback) ->
      @promise('post', '/warehouse', @toJSON()).then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .catch(callback)

    update: (callback) ->
      @promise('put', '/warehouse/' + @id, @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .catch(callback)

    delete: (callback) ->
      @promise('del', '/warehouse/' + @id, @toJSON())
      .then ->
        callback(null)
      .catch(callback)
