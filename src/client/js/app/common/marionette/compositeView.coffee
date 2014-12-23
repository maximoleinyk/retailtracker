define (require) ->
  'use strict'

  Marionette = require('marionette')
  mixin = require('cs!./mixin')

  Marionette.CompositeView.extend(mixin(Marionette.CompositeView))