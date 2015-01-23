define (require) ->
  'use strict'

  Collection = require('cs!app/common/collection')
  Store = require('cs!app/company/models/store')
  request = require('app/common/request')

  class Stores extends Collection

    model: Store

    fetch: ->
      request.get('/store/all').then (result) =>
        @reset(result, {parse: true})
