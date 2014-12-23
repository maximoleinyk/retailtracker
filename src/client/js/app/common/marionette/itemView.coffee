define (require) ->
  'use strict'

  Marionette = require('marionette')
  mixin = require('cs!./mixin')

  Marionette.ItemView.extend(mixin(Marionette.ItemView))