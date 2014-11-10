define (require) ->
  'use strict'

  MongoModel = require('app/common/mongoModel')

  class Account extends MongoModel

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