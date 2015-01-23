define (require) ->
  'use strict'

  Router = require('cs!app/common/router')
  context = require('cs!app/common/context')

  Router.extend

    appRoutes:
      '': 'dashboard'
      'choose': 'chooseCompany'
      'access': 'access'

      'companies': 'companies'
      'company/:id': 'companyForm'
      'company/:id/employees': 'manageCompanyEmployees'

      'settings/:view': 'settings'

    permissions:
      dashboard:
        permitted: ->
          context.get('account.dependsFrom').length is 0
        fallback: ->
          @navigate('choose', {trigger: true})
