define (require) ->
  'use strict'

  Backbone = require('backbone')
  Model = require('cs!./mongoModel')

  class MongoCollection extends Backbone.Collection
    model: Model