define (require) ->
  'use strict'

  Backbone = require('backbone')

  new Backbone.Wreqr.EventAggregator()
