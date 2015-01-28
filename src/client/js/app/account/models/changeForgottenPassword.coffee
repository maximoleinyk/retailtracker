define (require) ->
  'use strict'

  Model = require('app/common/model')
  i18n = require('cs!app/common/i18n')

  class ChangeForgottenPassword extends Model

    url: '/account/password/confirm'

    validators:
      password:
        exists: true
        description: ->
          i18n.get('passwordIsRequired')
      confirmPassword:
        exists: true
        description: ->
          i18n.get('pleaseConfirmPassword')
