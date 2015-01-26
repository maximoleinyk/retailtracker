define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  Promise = require('rsvp').Promise

  class PriceListTemplate extends Model

    urlRoot: '/pricelisttemplate'

    defaults:
      columns: []
