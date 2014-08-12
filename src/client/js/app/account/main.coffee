define (require) ->
  'use strict'

  Router = require('cs!./router')
  Controller = require('cs!./controller')

  (start) -> start({
    Router: Router
    Controller: Controller
    moduleName: 'app/account/main'
  })
