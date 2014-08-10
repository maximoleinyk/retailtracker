define (require) ->
  'use strict'

  Backbone = require('backbone')
  NotFound = require('cs!app/common/view/notFound')

  Backbone.Marionette.Controller.extend

    getLoadingView: ->
      return @loadingView if @loadingView

      @loadingView = Backbone.Marionette.ItemView.extend ->
        template: '<div></div>'

      @loadingView

    openPage: (view, options) ->
      options or= {}

      if (@pendingPage)
        @stopListening(@, 'showPage' + this.pendingPage.cid)
        @pendingPage = null

      if (typeof options.immediate is 'undefined' or options.immediate)
        return @eventBus.trigger('open:page', view, options)

      Loading = @getLoadingView()
      @eventBus.trigger('open:page', new Loading())
      @pendingPage = view

      @listenTo @, 'listener:' + @pendingPage.cid, =>
        @eventBus.trigger('open:page', @pendingPage)

      _.bind =>
        @trigger('listener:' + @pendingPage.cid)

    logout: ->
      http.del '/security/logout', =>
        @eventBus.trigger('router:reload');

    notFound: ->
      @openPage new NotFound
