define (require) ->
  'use strict'

  http = require('util/http')
  Marionette = require('marionette')
  sessionStore = require('util/sessionStore')

  Marionette.ItemView.extend
    template: require('hbs!./forgot')
