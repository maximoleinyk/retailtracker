define (require) ->
  'use strict'

  Model = require('app/common/model')
  i18n = require('cs!app/common/i18n')

  class Account extends Model

    validators:
      firstName:
        exists: true
        description: ->
          i18n.get('firstNameIsRequired')
      email:
        exists: true
        description: ->
          i18n.get('emailIsRequired')

    register: ->
      @save(null, {
        url: '/account/register'
      })

    forgotPassword: ->
      @save(null, {
        url: '/account/password/forgot'
      })
