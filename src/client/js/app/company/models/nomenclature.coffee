define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/model')

  class Nomenclature extends MongoModel

    defaults: ->
      attributes: []
      barcodes: []

    fetch: ->
      @promise('get', '/nomenclature/' + @id)
      .then (result) =>
        @set @parse(result)
        @commit()

    create: ->
      @promise('post', '/nomenclature/create', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    update: ->
      @promise('put', '/nomenclature/update', @toJSON())
      .then (result) =>
        @set @parse(result)
        @commit()

    delete: ->
      @promise('del', '/nomenclature/delete', @toJSON())
