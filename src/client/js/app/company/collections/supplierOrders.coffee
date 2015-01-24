define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  SupplierOrder = require('cs!app/company/models/supplierOrder')
  request = require('app/common/request')

  class SupplierOrders extends Collection

    model: SupplierOrder

    fetch: ->
      request.get('/supplierorders/all').then (result) =>
        @reset(result, {parse: true})
