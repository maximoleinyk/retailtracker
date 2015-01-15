define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  Employee = require('cs!app/company/models/employee')
  request = require('app/common/request')

  class Employees extends MongoCollection

    model: Employee

    fetch: (companyId) ->
      request.get('/employees/all' + if companyId then '/' + companyId else '').then (result) =>
        @reset(result, {parse: true})
