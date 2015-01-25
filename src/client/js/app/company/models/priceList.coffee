define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class PriceList extends Model

    urlRoot: '/pricelists'
    defaults:
      items: []
