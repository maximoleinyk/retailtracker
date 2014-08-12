define (require) ->
  'use strict'

  http = require('util/http')
  Marionette = require('marionette')

  Marionette.ItemView.extend
    template: require('hbs!./register')
