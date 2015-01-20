define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class Nomenclature extends Model

    defaults: ->
      attributes: []
      barcodes: []

    fetch: ->
      @promise('get', '/nomenclature/' + @id)
      .then (result) =>
        @set @parse(result)
        @commit()

    create: ->
      @promise('post', '/nomenclature', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    update: ->
      @promise('put', '/nomenclature/' + @id, @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    delete: ->
      @promise('del', '/nomenclature/' + @id, @toJSON())
