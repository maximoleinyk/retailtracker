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
    authUrl: '/context/handshake'

    beforeStart: (contextData) ->
      request.get('/context/load/brand')
      .then (contextData) ->
        context.set(context.parse(contextData))
        http.unsetHeader('company')
        http.setHeaders({ account: context.id })

  })
