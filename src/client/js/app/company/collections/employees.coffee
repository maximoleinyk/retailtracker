define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/collection')
  Employee = require('cs!app/company/models/employee')
  request = require('app/common/request')
  context = require('cs!app/common/context')

  class Employees extends MongoCollection

    model: Employee

    fetch: (companyId) ->
      foundCompanyLink = _.find context.get('account.companies'), (pair) ->
        pair.company is companyId
      accountId = if foundCompanyLink then foundCompanyLink.account else context.get('account._id')
      request.get('/employees/all/' + accountId + '/' + if companyId then companyId else '').then (result) =>
        @reset(result, {parse: true})
