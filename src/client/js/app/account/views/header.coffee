define (require) ->
  'use strict'

  Marionette = require('marionette')
  _ = require('underscore')

  Marionette.ItemView.extend

    template: require('hbs!./header.hbs')
    className: 'container'

    appEvents:
      'router:navigate': 'updateView'

    updateView: ->
      _.defer =>
        @render()

    templateHelpers: ->
      {
      isNotSignUp: window.location.href.indexOf('register') is -1
      }