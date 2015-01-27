define (require) ->
  'use strict'

  Backbone = require('backbone')
  Promise = require('rsvp').Promise
  http = require('./http')
  validators = require('./validators')

  require('backbone-nested')

  class Model extends Backbone.NestedModel

    staticProperties: ['error']

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

    unsetStatic: ->
      _.each @staticProperties, (property) =>
        @unset(property, {silent: true})

    save: ->
      @unsetStatic()
      save = new Promise (resolve, reject) =>
        Backbone.NestedModel::save.call(this).done(resolve).fail(reject)
      save.then (result) =>
        @set @parse(result)
        @commit()

    destroy: ->
      @unsetStatic()
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

    validate: ->
      return if not @validators
      errors = {}
      @trigger('validate')
      _.each @validators, (validator, key) =>
        _.each validator, (param, testName) =>
          return if testName is 'description'
          valid = if param then validators[testName](key, this) else validators[testName](key, param, this)
          if not valid
            errors[key] = errors[key] or []
            errors[key].push(validator.description)
      @set('error', errors) if _.keys(errors).length
      if _.isObject(@get('error')) and not _.isEmpty(@get('error')) then 'invalid' else null

    reset: ->
      @set(@origin)
