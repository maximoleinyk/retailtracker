define (require) ->
  'use strict'

  Backbone = require('backbone')
  Promise = require('rsvp').Promise
  http = require('util/http')

  class MongoModel extends Backbone.Model

    idAttribute: '_id'

    request: (method, url, data) ->
      new Promise (resolve, reject) ->
        http[method] url, data, (err, result) ->
          if err then reject(err) else resolve(result)

    parse: ->
      origin = super
      version = origin.__v
      this.version = version
      delete origin.__v;
      origin
