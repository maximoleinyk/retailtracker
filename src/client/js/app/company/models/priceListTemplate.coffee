define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class PriceListTemplate extends Model

    urlRoot: '/pricelisttemplate'

    defaults:
      columns: []
