define (require) ->
  'use strict'

  BaseRouter = require('cs!app/common/router')
  BaseRouter.extend
    appRoutes:
      '': 'home'
