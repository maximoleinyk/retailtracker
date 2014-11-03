define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  LoginPage = require('cs!./views/login')
  RegistrationPage = require('cs!./views/registration/main')
  RegistrationApprovePage = require('cs!./views/registration/confirm')
  ForgotPasswordPage = require('cs!./views/forgotPassword/main')
  PasswordChangePage = require('cs!./views/forgotPassword/change')
  Account = require('cs!./models/account')
  currentUser = require('util/userInfo')

  Controller.extend

    login: ->
      @openPage(new LoginPage)

    registerAccount: ->
      @openPage(new RegistrationPage)

    forgotPassword: ->
      @openPage(new ForgotPasswordPage)

    confirmAccountRegistration: (invite) ->
      account = new Account({
        link: invite
        email: currentUser.get('email')
      })
      @openPage new RegistrationApprovePage({
        model: account
      })

    changeForgottenPassword: (changeKey) ->
      account = new Account({
        key: changeKey
        email: currentUser.get('email')
      })
      @openPage new PasswordChangePage({
        model: account
      })
