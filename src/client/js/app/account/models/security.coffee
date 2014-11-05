define (require) ->
  'use strict'

  MongoModel = require('app/common/mongoModel')

  class Account extends MongoModel

    login: ->
      @promise('post', '/security/login', @toJSON())

    logout: ->
      @promise('del', '/security/logout', @toJSON())
