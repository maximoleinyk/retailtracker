define (require) ->
  'use strict'

  Marionette = require('marionette')
  Layout = require('cs!app/common/layout')
  context = require('cs!app/common/context')
  Backbone = require('backbone')

  Layout.extend

    el: '#app'
    template: require('hbs!./layout')

    appEvents:
      'router:navigate': 'hideNavigation'
      'http:401': 'redirectToLogin'
      'open:page': 'openPage'

    initialize: ->
      this.$el.addClass(@options.className) if @options.className

      Marionette.$(document).delegate('a[href^="/"]', 'click', _.bind(@navigateByLink, @))

    navigateByLink: (e) ->
      $el = $(e.currentTarget)
      href = $el.attr('href')
      enableHref = $el.data('enable-href')

      if (!enableHref and (href isnt '#') and !e.altKey and !e.ctrlKey and !e.metaKey and !e.shiftKey)
        e.preventDefault()
        @navigateTo(href.replace(new RegExp('^' + Backbone.history.root), ''))
        $(document).trigger('click.bs.dropdown')

    onRender: ->
      @displayNavigation()

    hideNavigation: (route) ->
      @header.close() if route is '404'

    displayNavigation: ->
      return if not @options.isAuthenticated or Backbone.history.fragment is '404'
      @header.show(new @options.Navigation(@options)) if @options.Navigation

    openPage: (view) ->
      @container.show(view)
      Marionette.$(document).scrollTop(0)

    redirectToLogin: (options) ->
      context.set('redirectUrl', options.fragment)

      switch (options.errorMessage)
        when 'Unauthorized' then window.location.replace('/page/account/login')
        when 'Unauthorized company' then @navigateTo('brand')
        else
          window.location.replace('/404')