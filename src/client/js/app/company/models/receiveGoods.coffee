define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class ReceiveGoods extends Model

    urlRoot: '/receivegoods'
