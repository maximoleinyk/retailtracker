define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  Model = require('cs!app/company/models/nomenclature')
  request = require('app/common/request')

  class Nomenclature extends MongoCollection

    model: Model

    fetch: ->
      request.get('/nomenclature/all').then (result) =>
        @reset(result, {parse: true})