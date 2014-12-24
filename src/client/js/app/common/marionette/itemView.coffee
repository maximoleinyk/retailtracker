define (require) ->
  'use strict'

  Marionette = require('marionette')
  mixin = require('./mixin')

  Marionette.ItemView.extend(mixin(Marionette.ItemView))