define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class SupplierOrder extends Model

    urlRoot: '/supplierorders'
