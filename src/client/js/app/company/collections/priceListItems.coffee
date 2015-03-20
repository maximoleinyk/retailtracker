define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  PriceListItem = require('cs!app/company/models/priceListItem')

  class PriceListItems extends Collection

    model: PriceListItem

    fetch: ->
      @promise('get', '/pricelistitems/all').then (result) =>
        @reset(result, {parse: true})

    fetchByPriceList: (priceListId) ->
      @promise('get', '/pricelistitems/list/' + priceListId)
