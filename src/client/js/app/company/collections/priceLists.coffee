define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  PriceList = require('cs!app/company/models/priceList')
  request = require('app/common/request')

  class PriceLists extends Collection

    model: PriceList

    fetch: ->
      request.get('/pricelists/all').then (result) =>
        @reset(result, {parse: true})
