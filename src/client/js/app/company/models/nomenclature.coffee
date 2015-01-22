define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  Promise = require('rsvp').Promise

  class Nomenclature extends Model

    urlRoot: '/nomenclature'

    defaults: ->
      attributes: []
      barcodes: []

    fetch: ->
      @promise('get', '/nomenclature/' + @id)
      .then (result) =>
        @set @parse(result)
        @commit()

    save: ->
      save = new Promise (resolve, reject) =>
        Model::save.apply(this, @toJSON()).done(resolve).fail(reject)
      save.then (result) =>
        @set @parse(result)
        @commit()

    delete: ->
      @promise('del', '/nomenclature/' + @id, @toJSON())
