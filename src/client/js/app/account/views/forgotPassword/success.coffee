define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.ItemView.extend
    template: require('hbs!./success.hbs')
    className: 'page page-box'
