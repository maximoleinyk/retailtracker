define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/mongoCollection')
  Company = require('cs!app/brand/models/company')

  class Companies extends MongoCollection

    model: Company

    fetch: ->
      @promise('get', '/company/all').then (result) =>
        @reset(result, {parse: true})