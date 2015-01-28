define (require) ->
  'use strict'

  Model = require('app/common/model')
  i18n = require('cs!app/common/i18n')

  class ForgotPassword extends Model

    url: '/account/password/forgot'

    validators:
      email:
        exists: true
        description: ->
          i18n.get('emailIsRequired')

    changeForgottenPassword: ->
      @save(null, {
        url: '/account/password/confirm'
      })
