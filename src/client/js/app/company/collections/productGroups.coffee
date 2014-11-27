define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/mongoCollection')
  ProductGroup = require('cs!app/company/models/productGroup')
  request = require('util/request')

  class ProductGroups extends MongoCollection

    model: ProductGroup

    fetch: ->
      request.get('/productgroup/all').then (result) =>
        @reset(result, {parse: true})