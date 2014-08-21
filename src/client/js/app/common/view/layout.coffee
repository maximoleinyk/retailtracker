define (require) ->
  'use strict'

  Marionette = require('marionette')
  sessionStore = require('util/sessionStore')

  Marionette.Layout.extend

    el: '#app'
    template: require('hbs!./layout')

    regions:
      navigation: '#navigation'
      container: '#container'

    appEvents:
      'router:navigate': 'hideNavigation'
      'http:401': 'redirectToLogin'
      'open:page': 'openPage'

    initialize: (options) ->
      @options = options

      Marionette.$(document).delegate 'a[href^="/"]', 'click', (e) =>
        $el = $(e.currentTarget)
        href = $el.attr('href')

        if (!$el.data('enable-href') and (href isnt '#') and !e.altKey and !e.ctrlKey and !e.metaKey and !e.shiftKey)
          e.preventDefault()

          url = href.replace(new RegExp('^' + Backbone.history.root), '')
          @eventBus.trigger('router:navigate', url, {trigger: true})

          $(document).trigger('click.bs.dropdown');

    onRender: ->
      @displayNavigation()

    hideNavigation: (route) ->
      @navigation.close() if route is '404'

    displayNavigation: ->
      return if not @options.isAuthenticated or Backbone.history.fragment is '404'
      @navigation.show(new @options.Navigation(@options)) if @options.Navigation

    openPage: (view) ->
      @container.show(view)

    redirectToLogin: ->
      sessionStore.add('redirectUrl', Backbone.history.fragment or 'default')
      window.location.replace('/page/account/login')
