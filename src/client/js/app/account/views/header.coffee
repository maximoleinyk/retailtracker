define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  _ = require('underscore')

  ItemView.extend

    template: require('hbs!./header.hbs')

    appEvents:
      'router:navigate': 'updateView'

    updateView: ->
      _.defer =>
        @render()

    templateHelpers: ->
      isNotSignUp: window.location.href.indexOf('register') is -1
