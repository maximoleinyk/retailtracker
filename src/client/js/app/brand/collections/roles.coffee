define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  Role = require('cs!app/brand/models/role')

  class Roles extends MongoCollection

    model: Role

    fetch: ->
      @promise('get', '/role/all').then (result) =>
        @reset(result, {parse: true})
