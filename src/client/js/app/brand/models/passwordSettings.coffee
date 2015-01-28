define (require) ->
  'use strict'

  Model = require('app/common/model')
  i18n = require('cs!app/common/i18n')

  class PasswordSettings extends Model

    urlRoot: '/settings/password'

    validators:
      oldPassword:
        exists: true
        description: ->
          i18n.get('oldPasswordIsRequired')
      password:
        exists: true
        description: ->
          i18n.get('newPasswordIsRequired')
      confirmPassword:
        exists: true
        description: ->
          i18n.get('pleaseConfirmPassword')
