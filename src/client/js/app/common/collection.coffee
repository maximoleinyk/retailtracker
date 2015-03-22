define (require) ->
  'use strict'

  Backbone = require('backbone')
  Model = require('cs!./model')
  request = require('app/common/request')

  class MongoCollection extends Backbone.Collection

    model: Model

    promise: (method, url, data) ->
      request[method.toLowerCase()](url, data)
