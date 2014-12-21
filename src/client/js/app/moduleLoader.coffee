define (require) ->
  'use strict'

  http = require('util/http')
  _ = require('underscore')
  context = require('cs!app/common/context')
  Promise = require('rsvp').Promise
  i18n = require('cs!app/common/i18n')
  Marionette = require('marionette')
  Layout = require('cs!app/common/views/layout')
  Backbone = require('backbone')
  Handlebars = require('handlebars')
  cookies = require('cookies')
  request = require('util/request')
  eventBus = require('util/eventBus')

  App = new Marionette.Application

  App.addInitializer ->
    Marionette.$(document).delegate 'a[href^="/"]', 'click', (e) ->
      $el = $(e.currentTarget)
      href = $el.attr('href')
      enableHref = $el.data('enable-href')

      if (!enableHref and (href isnt '#') and !e.altKey and !e.ctrlKey and !e.metaKey and !e.shiftKey)
        e.preventDefault()
        eventBus.trigger('router:navigate', href.replace(new RegExp('^' + Backbone.history.root), ''), {
          trigger: true
        })
        $(document).trigger('click.bs.dropdown')

  Module = Marionette.Module.extend
    initialize: ->
      @startWithParent = false
      return @

    onStart: (options) ->
      @layout = new Layout(options)
      @layout.render()
      @controller = new options.Controller(options)
      @router = new options.Router({
        controller: @controller
      })
      Backbone.history.start({
        pushState: true
        root: options.root
      })
    onStop: ->
      @router.destroy()
      @controller.destroy()
      @layout.close()
      Backbone.history.stop()
      $el = Marionette.$('<div id="app" class="app"></div>')
      Marionette.$('body').append($el)

  Marionette.Renderer.render = (compile, data) ->
    compile(_.extend(data, {
      i18n: i18n.getMessages()
      helpers: _.extend({}, Handlebars.helpers, i18n.getFunctions())
    }))

  class ModuleLoader

    constructor: (@root, @mappings) ->
      @currentLoadedModule = null
      @doubleSlashRegExp = /\/\//g
      @rootRegExp = new RegExp('^' + @root + '?')
      return this

    start: ->
      moduleName = null

      for route of @mappings
        do =>
          if @getPath().indexOf(route) is 0
            moduleName = @mappings[route]

      @load moduleName, (module, authenticated) =>
        options = @getOptions(module, authenticated)
        App.start(options)
        App.module(moduleName).start(options)

    getOptions: (module, authenticated) ->
      _.extend _.clone(module), {
        root: (@root + module.root).replace(@doubleSlashRegExp, '/')
        isAuthenticated: authenticated
      }

    getPath: ->
      loc = window.location
      origin = loc.origin or loc.protocol + '//' + loc.host
      loc.href.replace(origin, '').replace('#', '/').replace(@doubleSlashRegExp, '/').replace(@rootRegExp, '')

    load: (moduleName, startApp) ->
      path = @getPath()
      require ['cs!app/' + moduleName + '/main'], (module) =>

        # remember current loaded module
        @currentLoadedModule = moduleName

        # set default behaviour for beforeStart function
        if not _.isFunction(module.beforeStart)
          module.beforeStart = (result) ->
            new Promise (resolve) ->
              resolve(result)

        # create module
        App.module(moduleName, Module)

        # call initialize function if it is defined in module
        if _.isFunction(module.initialize)
          module.initialize(path)

        # fetch localization messages
        request.get('/i18n/messages/' + module.bundleName)
        .then (messages) ->
          i18n.init(messages)

          # check that user is authenticated
          request.get(module.authUrl)

        .then =>
          if path.indexOf('account/login') is 0
            # redirect user if it is authenticated and opened login page
            lastPath = context.get('lastAuthUrl')
            context.unset('lastAuthUrl')
            @loadModule(lastPath.split('/')[0])
          else
            # otherwise start module loading
            return module.beforeStart(path)

        .then (result) =>
          # invoke before app start callback if it exists
          if _.isFunction(module.onComplete)
            module.onComplete(result)
          # start application
          startApp(module, true)

        .then null, (error) =>
          if error is 'Unauthorized'
            if path.indexOf('account') isnt 0
              context.set('lastAuthUrl', path)
              @loadModule('account', 'login')
            else
              startApp(module, false)
          else if error is 'Unknown context'
            @loadModule('brand')
          else
            # handle real error

    loadModule: (moduleName, path) ->
      # moduleName can be optional
      moduleName = moduleName or @getPath().split('/')[0]

      # not found if we're trying to load the same page with unknown url
      return eventBus.trigger('404') if moduleName is @currentLoadedModule

      # not found if we don't know such module
      return eventBus.trigger('404') if _.values(@mappings).indexOf(moduleName) is -1

      # stop previous module
      App.module(@currentLoadedModule).stop()

      window.history.pushState({}, document.title, @root + moduleName + (if path then '/' + path else ''))

      # load new one
      @load moduleName, (module, authenticated) =>
        options = _.extend @getOptions(module, authenticated),
          redirectUrl: if path then path else null
        App.module(moduleName).start options