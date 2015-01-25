define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  PriceListTemplate = require('cs!app/company/models/priceListTemplate')
  request = require('app/common/request')

  class PriceListTemplates extends Collection

    model: PriceListTemplate

    fetch: ->
      request.get('/pricelisttemplate/all').then (result) =>
        @reset(result, {parse: true})
