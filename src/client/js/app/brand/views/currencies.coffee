define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.Layout.extend
    template: require('hbs!./currencies')