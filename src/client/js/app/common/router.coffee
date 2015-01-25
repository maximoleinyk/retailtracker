define (require) ->
  'use strict'

  Marionette = require('marionette')
  eventBus = require('cs!app/common/eventBus')
  _ = require('underscore')

  Marionette.AppRouter.extend

    eventBus: eventBus

    constructor: ->
      permissions = Marionette.getOption(this, 'permissions') || {}
      appRoutes = Marionette.getOption(this, 'appRoutes') || {}
      copy = _.clone(appRoutes)
      all = permissions['*']

      if all
        _.each appRoutes, (methodName, route) ->
          if _.isArray(all.except) and all.except.indexOf(methodName) is -1
            isPermitted = if _.isFunction(all.permitted) then all.permitted.apply(this) else all.permitted
            if !isPermitted
              delete copy[route]
      else
        _.each permissions, (config, methodName) =>
          isPermitted = if _.isFunction(config.permitted) then config.permitted.apply(this) else config.permitted
          if !isPermitted
            _.each appRoutes, (appMethodName, route) =>
              delete copy[route] if methodName is appMethodName

      this.originRoutes = _.clone(appRoutes)
      this.appRoutes = copy

      Marionette.AppRouter::constructor.apply @, arguments

      @listenTo eventBus, 'router:navigate:silent', (methodName) =>
        controller = Marionette.getOption(this, 'controller')
        controller.silent or= {}
        method = controller.silent[methodName]
        throw 'Silent route should be mapped to existing method' if not method
        method.call(controller)

      @listenTo eventBus, 'router:navigate', =>
        @navigate.apply(@, arguments)

    initialize: (options) ->
      @options = options

    routes:
      'redirect': -> # do nothing

      '*404': ->
        permissions = Marionette.getOption(this, 'permissions')
        originRoutes = Marionette.getOption(this, 'originRoutes')
        foundMethodName = null

        _.each originRoutes, (methodName, route) =>
          routeAsRegExp = @routeAsRegexp(route)
          if routeAsRegExp.test(Backbone.history.getFragment())
            foundMethodName = methodName

        if foundMethodName
          foundMethodName = if permissions['*'] then '*' else foundMethodName
          fallback = permissions[foundMethodName].fallback
          return if _.isFunction(fallback) then fallback.apply(this) else @navigate(fallback, {trigger: true})

        eventBus.trigger('module:load')

    routeAsRegexp: (route) ->
      optionalParam = /\((.*?)\)/g
      namedParam = /(\(\?)?:\w+/g
      splatParam = /\*\w+/g
      escapeRegExp = /[\-{}\[\]+?.,\\\^$|#\s]/g

      route = route.replace(escapeRegExp, '\\$&')
      .replace(optionalParam, '(?:$1)?')
      .replace namedParam, (match, optional) ->
        if optional then match else '([^/?]+)'
      .replace(splatParam, '([^?]*?)');

      new RegExp('^' + route + '(?:\\?([\\s\\S]*))?$')

    destroy: ->
      @stopListening(eventBus, 'router:navigate')
      @stopListening(eventBus, 'router:navigate:silent')

    navigateTo: (route, options = {trigger: true}) ->
      eventBus.trigger('router:navigate', route, options)
