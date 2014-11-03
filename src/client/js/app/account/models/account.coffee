define (require) ->
  'use strict'

  MongoModel = require('app/common/mongoModel')

  class Account extends MongoModel

    confirm: ->
      @request('post', '/account/confirm', @toJSON())

    register: ->
      @request('post', '/account/register', @model.toJSON())

    changePassword: ->
      @request('post', '/account/password/change', @model.toJSON())

    forgotPassword: ->
      @request('post', '/account/password/forgot', @model.toJSON())