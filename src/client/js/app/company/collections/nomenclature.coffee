define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/mongoCollection')
  Model = require('cs!app/company/models/nomenclature')
  request = require('util/request')

  class Nomenclature extends MongoCollection

    model: Model

    fetch: ->
      request.get('/nomenclature/all').then (result) =>
        @reset(result, {parse: true})