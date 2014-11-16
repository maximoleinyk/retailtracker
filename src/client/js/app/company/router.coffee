define (require) ->
  'use strict'

  Router = require('cs!app/common/router')

  Router.extend

    appRoutes:
      ':id': 'home'
      ':id/uom': 'uom'
      ':id/currency': 'currency'