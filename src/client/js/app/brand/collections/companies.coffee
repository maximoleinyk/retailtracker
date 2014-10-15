define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/mongoCollection')
  Company = require('cs!app/brand/models/company')
  request = require('util/request')

  class Companies extends MongoCollection

    model: Company

    fetch: ->
      request.get('/company/all').then (result) =>
        @reset(result, {parse: true})