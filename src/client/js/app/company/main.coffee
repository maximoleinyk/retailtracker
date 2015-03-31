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

    beforeStart: (url) ->
      companyId = url.split('/')[1]
      http.setHeaders {
        company: companyId
      }
      request.get('/context/company').then (result) ->
        context.set(result)

        companyAndAccount = _.find context.get('account.companies'), (pair) ->
          pair.company is companyId

        http.setHeaders {
          account: companyAndAccount.account
          company: companyId
        }
  })
