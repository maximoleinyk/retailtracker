define (require) ->
  'use strict'

  Router = require('cs!app/common/router')
  context = require('cs!app/common/context')

  Router.extend

    appRoutes:
      '': 'dashboard'
      'choose': 'chooseCompany'

      'companies': 'companies'
      'company/create': 'createCompany'
      'company/:id/edit': 'editCompany'
      'company/:id/employees': 'manageCompanyEmployees'

      'settings/:view': 'settings'

    permissions:
      dashboard:
        permitted: ->
          context.get('account.dependsFrom').length is 0
        fallback: ->
          @navigate('choose', {trigger: true})
