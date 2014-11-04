define (require) ->
  'use strict'

  MongoModel = require('app/common/mongoModel')

  class Account extends MongoModel

    confirm: ->
      @promise('post', '/account/confirm', @toJSON())

    register: ->
      @promise('post', '/account/register', @toJSON())

    changePassword: ->
      @promise('post', '/account/password/change', @toJSON())

    forgotPassword: ->
      @promise('post', '/account/password/forgot', @toJSON())