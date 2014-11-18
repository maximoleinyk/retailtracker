define (require) ->
  'use strict'

  Backbone = require('backbone')
  Model = require('cs!./mongoModel')
  http = require('util/http')

  class MongoCollection extends Backbone.Collection

    model: Model

    promise: (method, url, data) ->
      new Promise (resolve, reject) ->
        http[method] url, data, (err, result) ->
          if err then reject(err) else resolve(result)