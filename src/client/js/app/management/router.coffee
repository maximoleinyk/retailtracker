define (require) ->
  'use strict'

  BaseRouter = require('cs!app/common/baseRouter')
  BaseRouter.extend
    appRoutes:
      '': 'home'
