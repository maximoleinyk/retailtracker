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

    beforeStart: ->
      http.setHeaders {
        pos: url.split('/')[1]
      }
      request.get('/context/pos').then (result) ->
        context.set(result)
        http.setHeaders {
          account: result.account._id
          company: result.company._id
        }
  })
