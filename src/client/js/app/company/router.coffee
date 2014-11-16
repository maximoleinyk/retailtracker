define (require) ->
  'use strict'

  Router = require('cs!app/common/router')
  _ = require('underscore')

  Router.extend

    appRoutes:
      '': 'home'
      'uom': 'uom'
      'currency': 'currency'

    constructor: (options) ->
      appRoutes = {}
      _.each @appRoutes, (value, key) ->
        appRoutes[':id' + (if key then '/' + key else key)] = value

      @appRoutes = appRoutes
      @controller = options.controller

      Router::constructor.call(@, arguments)

    execute: (callback, args) ->
      callback.apply(@, [].slice.call(args, 1)) if callback