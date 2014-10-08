define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')

  ({
    Router: Router
    Controller: Controller
    bundleName: 'account'
    root: '/account/'
  })
