define (require) ->
  'use strict'

  Model = require('app/common/model')

  class Account extends Model

    login: ->
      @promise('post', '/security/login', @toJSON())

    logout: ->
      @promise('del', '/security/logout', @toJSON())
