define (require) ->
  'use strict'

  MongoModel = require('app/common/mongoModel')

  class Account extends MongoModel

    confirm: ->
      @request('post', '/account/confirm', @toJSON())

    register: ->
      @request('post', '/account/register', @toJSON())

    changePassword: ->
      @request('post', '/account/password/change', @toJSON())

    forgotPassword: ->
      @request('post', '/account/password/forgot', @toJSON())