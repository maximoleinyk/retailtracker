define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/mongoCollection')
  Employee = require('cs!app/company/models/employee')
  request = require('util/request')

  class Employees extends MongoCollection

    model: Employee

    fetch: ->
      request.get('/employees/all').then (result) =>
        @reset(result, {parse: true})