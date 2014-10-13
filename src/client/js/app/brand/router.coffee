define (require) ->
  'use strict'

  Router = require('cs!app/common/router')

  Router.extend

    appRoutes:
      '': 'home'
      'uom': 'uom'
      'currency': 'currency'
      'settings/:view': 'settings'
