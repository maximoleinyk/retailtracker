define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  Employee = require('cs!app/company/models/employee')
  request = require('app/common/request')

  class Employees extends MongoCollection

    model: Employee

    fetch: ->
      request.get('/employees/all').then (result) =>
        @reset(result, {parse: true})