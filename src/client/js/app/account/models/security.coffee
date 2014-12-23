define (require) ->
  'use strict'

  MongoModel = require('app/common/model')

  class Account extends MongoModel

    login: ->
      @promise('post', '/security/login', @toJSON())

    logout: ->
      @promise('del', '/security/logout', @toJSON())
