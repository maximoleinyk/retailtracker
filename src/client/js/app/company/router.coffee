define (require) ->
  'use strict'

  Router = require('cs!app/common/router')
  _ = require('underscore')
  context = require('cs!app/common/context')

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

    getFragment: ->
      fragment = Router::getFragment.apply(@, arguments)

      if fragment.indexOf('/') > -1
        return fragment.replace(fragment.substring(0, fragment.indexOf('/')), '')
      else
        return ''

    execute: (callback, args) ->
      callback.apply(@, [].slice.call(args, 1)) if callback

    navigate: (fragment, options) ->
      fragment = context.get('company')._id + fragment
      Router::navigate(fragment, options)
