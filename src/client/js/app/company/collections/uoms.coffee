define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/mongoCollection')
  Uom = require('cs!app/company/models/uom')
  request = require('util/request')

  class Uoms extends MongoCollection

    model: Uom

    fetch: ->
      request.get('/uom/all').then (result) =>
        @reset(result, {parse: true})