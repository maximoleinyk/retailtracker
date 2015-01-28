define (require) ->
  'use strict'

  Model = require('app/common/model')
  i18n = require('cs!app/common/i18n')

  class Invite extends Model

    validators:
      password:
        exists: (model) ->
          not model.get('hasAccount')
        description: ->
          i18n.get('passwordIsRequired')
      confirmPassword:
        exists: (model) ->
          not model.get('hasAccount')
        description: ->
          i18n.get('pleaseConfirmPassword')

    confirmAccountRegistration: ->
      @save(null, {
        url: '/account/register/confirm'
      })

    confirmCompanyInvite: ->
      @save(null, {
        url: '/account/invite/confirm'
      })
