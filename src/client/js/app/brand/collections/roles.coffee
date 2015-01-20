define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  Role = require('cs!app/brand/models/role')

  class Roles extends MongoCollection

    model: Role

    comparator: (model) ->
      name = model.get('name')
      return 3 if name is 'BOSS'
      return 2 if name is 'MANAGER'
      return 1 if name is 'CASHIER'
      0

    fetch: ->
      @promise('get', '/roles/all/available').then (result) =>
        @reset(result, {parse: true})

    fetchAll: ->
      @promise('get', '/roles/all').then (result) =>
        @reset(result, {parse: true})
