define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Header = require('cs!./views/header')
  http = require('app/common/http')
  context = require('cs!app/common/context')
  request = require('app/common/request')

  ({
    Router: Router
    Controller: Controller
    Header: Header
    bundleName: 'company'
    classSelector: 'app-company'
    root: '/company/'
    authUrl: '/security/handshake'

    initialize: (url) ->
      http.setHeaders({ company: url.split('/')[1] })

    beforeStart: (url) ->
      companyId = url.split('/')[1]

      request.get('/context/load/company')
      .then (account) ->
        context.set({
          account: account
        })
        request.post('/company/' + companyId + '/permission/' + account.owner._id)

      .then (result) ->
        throw 'Unknown context' if not result

        context.set({
          company: result.company
          employee: result.employee
        })

        companyAndAccount = _.find context.get('account.companies'), (pair) ->
          pair.company is context.get('company._id')

        http.setHeaders({
          account: companyAndAccount.account
          company: context.get('company._id')
        })

        return request.get('/roles/' + result.employee.role + '/account/' + companyAndAccount.account)

      .then (role) ->
        context.set('employee.role', role)
  })
