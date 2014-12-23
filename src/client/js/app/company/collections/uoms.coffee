define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  Uom = require('cs!app/company/models/uom')
  request = require('app/common/request')

  class Uoms extends MongoCollection

    model: Uom

    fetch: ->
      request.get('/uom/all').then (result) =>
        @reset(result, {parse: true})