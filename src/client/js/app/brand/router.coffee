define (require) ->
  'use strict'

  Router = require('cs!app/common/router')

  Router.extend

    appRoutes:
      '': 'dashboard'

      'company/create': 'createCompany'
      'company/:id/edit': 'editCompany'

      'settings/:view': 'settings'
