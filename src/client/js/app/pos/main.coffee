define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')

  ({
    Router: Router
    Controller: Controller
    bundleName: 'pos'
    classSelector: 'point-of-sale'
    root: '/pos/'
    authUrl: '/context/handshake'
  })
