define (require) ->
  'use strict'

  Router = require('cs!app/common/router')

  Router.extend

    appRoutes:
      '': 'home'

      'company/create': 'createCompany'
      'company/:id': 'viewCompany'
      'company/:id/edit': 'editCompany'

      'settings/:view': 'settings'
