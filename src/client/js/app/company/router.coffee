define (require) ->
  'use strict'

  Router = require('cs!app/common/router')
  Router.extend
    appRoutes:
      '': 'home'