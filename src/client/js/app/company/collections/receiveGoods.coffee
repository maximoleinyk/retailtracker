define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  ReceiveGoods = require('cs!app/company/models/receiveGoods')
  request = require('app/common/request')

  class ReceiveGoodsCollection extends Collection

    model: ReceiveGoods

    fetch: ->
      request.get('/receivegoods/all').then (result) =>
        @reset(result, {parse: true})
