define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  ProductGroup = require('cs!app/company/models/productGroup')
  request = require('app/common/request')

  class ProductGroups extends MongoCollection

    model: ProductGroup

    fetch: ->
      request.get('/productgroup/all').then (result) =>
        @reset(result, {parse: true})