define (require) ->
  'use strict'

  Router = require('cs!app/common/router')
  _ = require('underscore')
  context = require('cs!app/common/context')

  Router.extend

    appRoutes:
      '': 'dashboard'

      'uom': 'uom'
      'currency': 'currency'
      'counterparty': 'listCounterparties'
      'counterparty/:id': 'counterpartyForm'
      'groups': 'productGroups'

      'settings/:view': 'settings'

      'nomenclature': 'nomenclatureList'
      'nomenclature/copy/:id': 'copyNomenclature'
      'nomenclature/:id': 'nomenclatureForm'

      'warehouses': 'warehouses'

      'choose': 'choose'

    permissions:
      '*':
        except: 'choose'
        permitted: ->
          context.get('employee.role.name') is 'BOSS' or context.get('employee.role.name') is 'MANAGER'
        fallback: ->
          @navigate('/choose', {trigger: true})

    constructor: (options) ->
      appRoutes = {}
      _.each @appRoutes, (value, key) ->
        appRoutes[':id' + (if key then '/' + key else key)] = value

      @appRoutes = appRoutes
      @controller = options.controller

      Router::constructor.call(@, arguments)

    execute: (callback, args) ->
      callback.apply(@, [].slice.call(args, 1)) if callback

    navigate: (fragment, options) ->
      companyId = context.get('company._id')

      if fragment is 'redirect'
        fragment = companyId + '/' + fragment
      else if fragment isnt 'redirect' and not (fragment.indexOf(companyId) is 0)
        fragment = companyId + fragment

      Router::navigate(fragment, options)
