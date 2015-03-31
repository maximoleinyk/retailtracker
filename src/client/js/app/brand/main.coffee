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
    bundleName: 'brand'
    classSelector: 'app-brand'
    root: '/brand/'
    authUrl: '/security/handshake'

    beforeStart: ->
      request.get('/context/brand').then (account) ->
        context.set('account', account)
        http.setHeaders {
          account: account._id
          company: undefined
          pos: undefined
        }
  })
