define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class Role extends Model

    fetch: ->
      @promise('get', '/roles/' + @id)
      .then (result) =>
        @set @parse(result)
        @commit()
