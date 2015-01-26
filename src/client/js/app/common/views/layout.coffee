define (require) ->
  'use strict'

  Marionette = require('marionette')
  Layout = require('cs!app/common/marionette/layout')
  context = require('cs!app/common/context')
  PopupBox = require('cs!app/common/views/popupBox/main')
  i18n = require('cs!app/common/i18n')
  request = require('app/common/request')
  http = require('app/common/http')
  cookies = require('cookies')
  NotFoundPage = require('cs!app/common/views/notFound')
  Footer = require('cs!app/common/views/footer')

  Layout.extend

    el: '#app'
    template: require('hbs!./layout.hbs')

    appEvents:
      'http:403': 'handleForbidden'
      'http:401': 'handleUnauthorized'
      '404': 'pageNotFound'
      'open:page': 'displayContent'
      'popup:show': 'showPopupBox'
      'http:request:start': 'handleStartRequest'
      'http:request:stop': 'handleStopRequest'

    initialize: ->
      this.$el.addClass(@options.classSelector) if @options.classSelector
      this.requestCount = 0

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

    handleStartRequest: ->
      this.requestCount++
      this.$el.find('[data-auto-disable]').attr('disabled', true)

    handleStopRequest: ->
      this.requestCount--
      this.$el.find('[data-auto-disable]').removeAttr('disabled') if not this.requestCount

    onRender: ->
      @displayHeader()
      @displayFooter()

    displayFooter: ->
      @footer.show(new Footer(@options))

    displayHeader: ->
      @header.show(new @options.Header(@options)) if @options.Header

    displayContent: (view) ->
      @container.show(view)
      Marionette.$(document).scrollTop(0)

    showPopupBox: (box) ->
      @popup.show(box)

    pageNotFound: ->
      @popup?.close()
      @navigation?.close()
      @container.show(new NotFoundPage)

    handleUnauthorized: (error) ->
      if error is 'Unauthorized'
        location = window.location
        origin = location.origin or location.protocol + '//' + location.host
        origin = location.href.replace(origin, '').replace('#', '/').replace(/\/\//g, '/').replace(/^\/page\/?/, '')
        context.set('lastAuthUrl', origin)
        @eventBus.trigger('module:load', 'account', 'login')
      else if error is 'Unauthorized company'
        @navigateTo('brand')
      else
        @eventBus.trigger('404')
