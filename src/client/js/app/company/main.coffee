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
    authUrl: '/context/handshake'

    initialize: (url) ->
      http.setHeaders({ company: url.split('/')[1] })

    beforeStart: (url) ->
      companyId = url.split('/')[1]

      request.get('/context/load/company')
      .then (account) ->
        context.set({
          account: account
        })
        request.get('/company/' + companyId + '/permission/' + account.owner._id)

      .then (result) ->
        throw 'Unknown context' if not result
        context.set({
          company: result.company
          employee: result.employee
        })
        http.setHeaders({
          account: context.get('account._id')
          company: context.get('company._id')
        })
  })
