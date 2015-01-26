define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  Promise = require('rsvp').Promise

  class SupplierOrder extends Model

    urlRoot: '/supplierorders'
