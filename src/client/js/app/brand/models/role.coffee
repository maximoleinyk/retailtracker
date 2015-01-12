define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/model')
  context = require('cs!app/common/context')

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
