define (require) ->
  'use strict'

  Router = require('cs!app/common/router')

  Router.extend

    appRoutes:
      '': 'dashboard'

      'companies': 'companies'
      'company/create': 'createCompany'
      'company/:id/edit': 'editCompany'
      'company/:id/employees': 'manageCompanyEmployees'

      'settings/:view': 'settings'
