define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  Counterparty = require('cs!app/company/models/counterparty')
  request = require('app/common/request')

  class Counterparties extends MongoCollection

    model: Counterparty

    fetch: ->
      @promise('get', '/counterparty/all').then (result) =>
        @reset(result, {parse: true})