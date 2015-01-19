define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/model')

  class Role extends MongoModel

    fetch: ->
      @promise('get', '/roles/' + @id)
      .then (result) =>
        @set @parse(result)
        @commit()
