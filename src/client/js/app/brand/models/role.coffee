define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/model')

  class Role extends MongoModel

    create: ->
      @promise('post', '/role/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    fetch: ->
      @promise('get', '/role/' + @id)
      .then (result) =>
        @set @parse(result)
        @commit()
