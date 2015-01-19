define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  Role = require('cs!app/brand/models/role')

  class Roles extends MongoCollection

    model: Role

    fetch: ->
      @promise('get', '/roles/all/available').then (result) =>
        @reset(result, {parse: true})

    fetchAll: ->
      @promise('get', '/roles/all').then (result) =>
        @reset(result, {parse: true})
