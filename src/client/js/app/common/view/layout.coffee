define (require) ->
  'use strict'

  Marionette = require('marionette')
  sessionStore = require('util/sessionStore')

  Marionette.Layout.extend

    el: '#app'
    template: require('hbs!./layout')

    regions:
      header: '#header'
      container: '#container'

    appEvents:
      'router:navigate': 'hideHeader'
      'http:401': 'redirectToLogin'
      'open:page': 'openPage'

    initialize: (options) ->
      @options = options

      Marionette.$(document).on 'click', 'a[href^="/"]', (e) =>
        $el = $(e.currentTarget)
        href = $el.attr('href')

        if (!$el.data('enable-href') and (href isnt '#') and !e.altKey && !e.ctrlKey && !e.metaKey && !e.shiftKey)
          e.preventDefault()

          url = href.replace(new RegExp('^' + Backbone.history.root), '')
          @eventBus.trigger('router:navigate', url, {trigger: true})

          $(document).trigger('click.bs.dropdown');

    onRender: ->
      @displayHeader()

    hideHeader: (route) ->
      @header.close() if route is '404'

    displayHeader: ->
      return if not @options.isAuthenticated or Backbone.history.fragment is '404'
      @header.show(new @options.Header(@options)) if @options.Header

    openPage: (view) ->
      @container.show(view)

    redirectToLogin: ->
      sessionStore.add('redirectUrl', Backbone.history.fragment or 'default')
      window.location.replace('/page/account/login')
