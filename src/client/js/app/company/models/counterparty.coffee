define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class Counterparty extends Model

    fetch: ->
      @promise('get', '/counterparty/' + @id).then (result) =>
        @set @parse(result)

    create: ->
      @promise('post', '/counterparty', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    update: ->
      @promise('put', '/counterparty/' + @id, @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    delete: ->
      @promise('del', '/counterparty/' + @id, @toJSON())
