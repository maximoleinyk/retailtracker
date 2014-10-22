define (require) ->
  'use strict'

  Marionette = require('marionette')
  Marionette.CompositeView.extend
    template: require('hbs!./list')