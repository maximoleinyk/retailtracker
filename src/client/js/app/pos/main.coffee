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
    bundleName: 'pos'
    classSelector: 'app-pos'
    root: '/pos/'
    authUrl: '/security/handshake'

    beforeStart: (url) ->
      posId = url.split('/')[1]
      http.setHeaders {
        pos: posId
      }
      request.get('/context/pos').then (result) ->
        context.set(result)

        companyAndAccount = _.find context.get('account.companies'), (pair) ->
          pair.company is context.get('company._id')

        http.setHeaders {
          account: companyAndAccount.account
          company: result.company._id
        }
  })
