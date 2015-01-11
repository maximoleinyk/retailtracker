define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  _ = require('underscore')
  Backbone = require('backbone')

  ItemView.extend

    template: require('hbs!./header.hbs')

    initialize: ->
      @listenTo(Backbone.history, 'route', this.updateView, this)

    updateView: ->
      _.defer =>
        @render()

    templateHelpers: ->
      isNotSignUp: window.location.href.indexOf('register') is -1
