define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')
  Navigation = require('cs!./views/navigation')
  http = require('util/http')
  context = require('cs!app/common/context')

  ({
    Router: Router
    Controller: Controller
    Navigation: Navigation
    bundleName: 'brand'
    className: 'brand'
    root: '/brand/'
    contextUrl: '/context/load/brand'

    onComplete: (accountInfo) ->
      context.set(accountInfo)
      http.setHeaders({ account: accountInfo._id })

  })
