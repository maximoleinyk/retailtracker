define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  LoginPage = require('cs!./view/login')
  RegistrationPage = require('cs!./view/registration/main')
  RegistrationApprovePage = require('cs!./view/registration/approve')
  ForgotPasswordPage = require('cs!./view/forgotPassword/main')
  PasswordChangePage = require('cs!./view/forgotPassword/change')
  Account = require('cs!./model/account')

  Controller.extend

    login: ->
      @openPage(new LoginPage)

    registration: ->
      @openPage(new RegistrationPage)

    forgotPassword: ->
      @openPage(new ForgotPasswordPage)

    confirmRegistration: (inviteKey) ->
      account = new Account()
      account.loadInvite({id: inviteKey})
      .then =>
        @openPage(new RegistrationApprovePage({model: account}))
      .then null, =>
        @eventBus.trigger('router:navigate', 'account/login', {trigger: true})

    changeForgottenPassword: (changeKey) ->
      account = new Account()
      account.loadLink({id: changeKey})
      .then =>
        @openPage(new PasswordChangePage({model: account}))
      .then null, =>
        @eventBus.trigger('router:navigate', 'account/login', {trigger: true})