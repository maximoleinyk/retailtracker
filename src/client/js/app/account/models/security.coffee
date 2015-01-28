define (require) ->
  'use strict'

  Model = require('app/common/model')
  i18n = require('cs!app/common/i18n')

  class Security extends Model

    validators:
      login:
        exists: true
        description: ->
          i18n.get('loginIsRequired')
      password:
        exists: true
        description: ->
          i18n.get('passwordIsRequired')

    login: ->
      @save(null, {
        url: '/security/login'
      })

    logout: ->
      # this request should be a standalone
      @promise('del', '/security/logout', @toJSON())
