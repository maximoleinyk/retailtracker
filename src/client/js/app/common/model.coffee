define (require) ->
  'use strict'

  Backbone = require('backbone')
  Promise = require('rsvp').Promise
  http = require('./http')
  validators = require('./validators')
  _ = require('underscore')

  require('backbone-nested')

  class Model extends Backbone.NestedModel

    staticProperties: ['errors']

    initialize: ->
      @commit()

    commit: ->
      @origin = @toJSON()

    fetch: ->
      fetch = new Promise (resolve, reject) =>
        Backbone.NestedModel::fetch.call(this, {
          success: (model) ->
            resolve(model.toJSON())
          error: (model, xhr) ->
            if xhr.responseJSON
              model.set(xhr.responseJSON)
            else
              model.set('errors', {generic: xhr.responseText})
            model.trigger('invalid')
            reject(model)
        }).done(resolve).fail(reject)

      fetch.then (result) =>
        @set @parse(result)
        @commit()

    promise: (method, url, data) ->
      new Promise (resolve, reject) ->
        http[method] url, data, (err, result) ->
          if err then reject(err) else resolve(result)

    sync: (method, model, options = {}) ->
      _.each @staticProperties, (property) =>
        @unset(property, {silent: true})

      _.defaults(options, {
        statusCode: http.statusCode
      })

      Backbone.NestedModel::sync.apply(this, arguments)

    save: (attributes = {}, options = {}) ->
      save = new Promise (resolve, reject) =>
        Backbone.NestedModel::save.call(this, attributes, _.extend({
          success: (model) ->
            resolve(model.toJSON())
          error: (model, xhr) ->
            if xhr.responseJSON
              model.set(xhr.responseJSON)
            else
              model.set('errors', {generic: xhr.responseText})
            model.trigger('invalid')
            reject(model)
        }, options)).done(resolve).fail(reject)
      save.then (result) =>
        @set @parse(result)
        @commit()

    destroy: (options) ->
      destroy = new Promise (resolve, reject) =>
        Backbone.NestedModel::destroy.call(this, _.extend({
          success: (model) ->
            resolve(model.toJSON())
          error: (model, xhr) ->
            if xhr.responseJSON
              model.set(xhr.responseJSON)
            else
              model.set('errors', {generic: xhr.responseText})
            model.trigger('invalid')
            reject(model)
        }, options))
      destroy.then (result) =>
        @set @parse(result)
        @commit()

    parse: ->
      origin = super
      return {} if not origin
      version = origin.__v
      id = origin._id or origin.id
      this.version = version
      delete origin.__v
      delete origin._id
      origin.id = id
      return origin

    validate: (options = {}) ->
      return if not @validators
      errors = {}
      @trigger('validate')
      _.each @validators, (validator, key) =>
        _.each validator, (param, testName) =>
          return if testName is 'description'

          method = validators[testName]
          param = if _.isFunction(param) then param(this) else param

          if _.isBoolean(param)
            if param
              valid = method(key, this)
            else
              valid = true
          else
            valid = method(key, param, this)

          if not valid
            localizedText = if _.isFunction(validator.description) then validator.description() else validator.description
            errors[key] = errors[key] or []
            errors[key].push(localizedText)
      @set('errors', errors) if _.keys(errors).length
      if _.isObject(@get('errors')) and not _.isEmpty(@get('errors'))
        return 'invalid'
      else
        options.sync and this.trigger('sync')
        return null

    reset: ->
      @set(@origin)
