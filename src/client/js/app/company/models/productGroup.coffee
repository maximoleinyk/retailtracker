define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class ProductGroup extends Model

    create: (callback) ->
      @promise('post', '/productgroup', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .catch(callback)

    update: (callback) ->
      @promise('put', '/productgroup/' + @id, @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .catch(callback)

    delete: (callback) ->
      @promise('del', '/productgroup/' + @id, @toJSON())
      .then ->
        callback(null)
      .catch(callback)
