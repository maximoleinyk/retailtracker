define (require) ->
  'use strict'

  Marionette = require('marionette')
  Layout = require('cs!app/common/layout')
  context = require('cs!app/common/context')
  Backbone = require('backbone')
  PopupBox = require('cs!app/common/views/popupBox/main')
  i18n = require('cs!app/common/i18n')
  request = require('util/request')
  http = require('util/http')
  cookies = require('cookies')
  NotFoundPage = require('cs!app/common/views/notFound')

  Layout.extend

    el: '#app'
    template: require('hbs!./layout.hbs')

    appEvents:
      'http:403': 'handleForbidden'
      'http:401': 'handleUnauthorized'
      '404': 'pageNotFound'
      'open:page': 'displayContent'
      'popup:show': 'showPopupBox'

    initialize: ->
      this.$el.addClass(@options.classSelector) if @options.classSelector
      Marionette.$(document).delegate('a[href^="/"]', 'click', _.bind(@navigateByLink, @))

    handleForbidden: (obj) ->
      if obj.error is 'CSRF has expired'
        PopupBox.context({
          title: i18n.get('sessionExpired')
          message: i18n.get('sessionExpiredMessage')
          buttons: [
            {
              label: i18n.get('resumeSession')
              primary: true
              action: (view) ->
                request.get('/context/handshake')
                .then ->
                  http.setHeaders({
                    'X-Csrf-Token': cookies.get('X-Csrf-Token')
                  },)
                  view.close()
            }
          ]
        })
      else if @options.isAuthenticated
        window.location.reload()

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
      @header.show(new @options.Header(@options)) if @options.Header

    displayNavigation: ->
      @navigation.show(new @options.Navigation(@options)) if @options.Navigation

    displayContent: (view) ->
      @container.show(view)
      Marionette.$(document).scrollTop(0)

    showPopupBox: (box) ->
      @popup.show(box)

    pageNotFound: ->
      @popup.close()
      @navigation.close()
      @container.show(new NotFoundPage)

    handleUnauthorized: (options) ->
      context.set('lastAuthUrl', options.fragment)

      switch (options.errorMessage)
        when 'Unauthorized' then window.location.replace('/page/account/login')
        when 'Unauthorized company' then @navigateTo('brand')
        else
          @eventBus.trigger('404')