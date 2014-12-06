define (require) ->
  'use strict'

  Marionette = require('marionette')
  Layout = require('cs!app/common/layout')
  context = require('cs!app/common/context')
  Backbone = require('backbone')

  Layout.extend

    el: '#app'
    template: require('hbs!./layout.hbs')

    appEvents:
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
      @displayHeader()
      @displayNavigation()

    displayHeader: ->
      return if not @options.Header
      @header.show(new @options.Header(@options))

    displayNavigation: ->
      return if not @options.Navigation
      @navigation.show(new @options.Navigation(@options))

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