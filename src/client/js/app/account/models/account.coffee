define (require) ->
  'use strict'

  Model = require('app/common/model')

  class Account extends Model

    confirm: ->
      @promise('post', '/account/register/confirm', @toJSON())

    register: ->
      @promise('post', '/account/register', @toJSON())

    changePassword: ->
      @promise('post', '/account/password/change', @toJSON())

    forgotPassword: ->
      @promise('post', '/account/password/forgot', @toJSON())

    changeForgottenPassword: ->
      @promise('post', '/account/password/confirm', @toJSON())

    confirmCompanyInvite: ->
      @promise('post', '/account/invite/confirm', @toJSON())
