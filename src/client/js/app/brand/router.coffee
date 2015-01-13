define (require) ->
  'use strict'

  Router = require('cs!app/common/router')

  Router.extend

    appRoutes:
      '': 'dashboard'

      'chooseCompany': 'chooseCompany'
      'choosePos': 'choosePos'

      'companies': 'companies'
      'company/create': 'createCompany'
      'company/:id/edit': 'editCompany'
      'company/:id/employees': 'manageCompanyEmployees'

      'settings/:view': 'settings'
