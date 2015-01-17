define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')

  ({
    Router: Router
    Controller: Controller
    bundleName: 'pos'
    className: 'point-of-sale'
    root: '/pos/'
    authUrl: '/context/handshake'
  })
