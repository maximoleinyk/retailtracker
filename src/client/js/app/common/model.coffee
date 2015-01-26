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

    sync: (method, model, options = {}) ->
      _.defaults(options, {
        statusCode: http.statusCode
      });
      Backbone.NestedModel::sync.apply(this, arguments);

    save: ->
      save = new Promise (resolve, reject) =>
        Backbone.NestedModel::save.call(this, @toJSON()).done(resolve).fail(reject)
      save.then (result) =>
        @set @parse(result)
        @commit()

    destroy: ->
      destroy = new Promise (resolve, reject) =>
        Backbone.NestedModel::destroy.call(this).done(resolve).fail(reject)
      destroy.then (result) =>
        @set @parse(result)
        @commit()

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
