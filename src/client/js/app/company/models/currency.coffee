define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class Currency extends Model

    defaults:
      rate: 1
      code: 'USD'

    getTemplates: ->
      @promise('get', '/currency/templates')

    create: (callback) ->
      @promise('post', '/currency', @toJSON()).then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .catch(callback)

    update: (callback) ->
      @promise('put', '/currency/' + @id, @toJSON()).then (result) =>
        @set @parse(result)
        @commit()
        callback(null, @)
      .catch(callback)

    delete: (callback) ->
      @promise('del', '/currency/' + @id, @toJSON()).then ->
        callback(null)
      .catch(callback)
