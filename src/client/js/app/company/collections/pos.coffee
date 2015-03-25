define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  Pos = require('cs!app/company/models/pos')
  request = require('app/common/request')

  class PosCollection extends Collection

    model: Pos

    fetch: ->
      request.get('/pos/all').then (result) =>
        @reset(result, {parse: true})
