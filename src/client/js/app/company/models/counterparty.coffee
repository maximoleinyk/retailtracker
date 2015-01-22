define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  Promise = require('rsvp').Promise

  class Counterparty extends Model

    urlRoot: '/counterparty'

    fetch: ->
      @promise('get', '/counterparty/' + @id).then (result) =>
        @set @parse(result)

    save: ->
      save = new Promise (resolve, reject) =>
        Model::save.apply(this, @toJSON()).done(resolve).fail(reject)
      save.then (result) =>
        @set @parse(result)
        @commit()

    delete: ->
      @promise('del', '/counterparty/' + @id, @toJSON())
