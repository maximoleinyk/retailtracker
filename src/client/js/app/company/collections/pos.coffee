define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  Pos = require('cs!app/company/models/pos')
  request = require('app/common/request')

  class PosCollection extends Collection

    model: Pos

    fetchAllowedPos: (employeeId, storeId) ->
      data =
        employee: employeeId
        store: storeId
      request.post('/pos/allowed', data).then (result) =>
        @reset(result, {parse: true})

    fetch: ->
      request.get('/pos/all').then (result) =>
        @reset(result, {parse: true})
