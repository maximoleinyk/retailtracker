define (require) ->
  'use strict'

  Backbone = require('backbone')
  Promise = require('rsvp').Promise
  http = require('app/common/http')

  require('backbone-nested')

  class Model extends Backbone.NestedModel

    initialize: ->
      @commit()

    commit: ->
      @origin = @toJSON()

    promise: (method, url, data) ->
      new Promise (resolve, reject) ->
        http[method] url, data, (err, result) ->
          if err then reject(err) else resolve(result)

    parse: ->
      origin = super

      version = origin.__v
      id = origin._id or origin.id

      this.version = version

      delete origin.__v
      delete origin._id

      origin.id = id

      origin

    reset: ->
      @set(@origin)
