define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class Uom extends Model

    create: (callback) ->
      @promise('post', '/uom', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .catch(callback)

    update: (callback) ->
      @promise('put', '/uom/' + @id, @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .catch(callback)

    delete: (callback) ->
      @promise('del', '/uom/' + @id, @toJSON())
      .then ->
        callback(null)
      .catch(callback)
