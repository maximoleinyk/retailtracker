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

      'settings/:view': 'settings'

      'nomenclature': 'nomenclatureList'
      'nomenclature/create': 'createNomenclature'
      'nomenclature/:id': 'viewNomenclature'
      'nomenclature/:id/edit': 'editNomenclature'

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
      fragment = context.get('company')._id + fragment
      Router::navigate(fragment, options)
