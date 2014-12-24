define (require) ->
  'use strict'

  Marionette = require('marionette')
  mixin = require('./mixin')

  Marionette.CompositeView.extend(mixin(Marionette.CompositeView))