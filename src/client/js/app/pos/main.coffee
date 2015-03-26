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

    initialize: (url) ->
#      http.setHeaders({ pos: url.split('/')[1] })

    beforeStart: ->
#      context.set({
#        account: null
#        company: null
#        employee: null
#        role: null
#      })
  })
