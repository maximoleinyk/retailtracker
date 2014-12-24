define (require) ->
  'use strict'

  Wreqr = require('backbone.wreqr')

  new Wreqr.EventAggregator()
