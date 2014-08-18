define (require) ->
  'use strict'

  BaseController = require('cs!app/common/controller');
  LoginPage = require('cs!./view/login')
  RegistrationPage = require('cs!./view/register')
  RegistrationSuccessPage = require('cs!./view/success')
  RegistrationApprovePage = require('cs!./view/approve')
  ForgotPasswordPage = require('cs!./view/forgot')
  ForgotPasswordSuccessPage = require('cs!./view/forgotSuccess')
  Invite = require('cs!./model/invite')
  ChangePassword = require('cs!./model/changePassword')
  PasswordChangePage = require('cs!./view/changePassword')
  RegistrationCompletedPage = require('cs!./view/registrationCompleted')
  PasswordSuccessfullyChangedPage = require('cs!./view/passwordChangedSuccess')

  BaseController.extend

    login: ->
      @openPage(new LoginPage)

    registration: ->
      @openPage(new RegistrationPage)

    forgotPassword: ->
      @openPage(new ForgotPasswordPage)

    registrationConfirm: (inviteKey) ->
      invite = new Invite({id: inviteKey})
      invite.fetch()
      .then =>
        @openPage(new RegistrationApprovePage({model: invite}))
      .then null, =>
        @eventBus.trigger('router:navigate', 'account/login', {trigger: true})

    forgotPasswordConfirm: (changeKey) ->
      passwordChange = new ChangePassword({id: changeKey})
      passwordChange.fetch()
      .then =>
        @openPage(new PasswordChangePage({model: passwordChange}))
      .then null, =>
        @eventBus.trigger('router:navigate', 'account/login', {trigger: true})

    silent:
      registrationInviteSent: ->
        @openPage(new RegistrationSuccessPage)

      registrationCompleted: ->
        @openPage(new RegistrationCompletedPage)

      forgotPasswordLinkSent: ->
        @openPage(new ForgotPasswordSuccessPage)

      forgotPasswordChanged: ->
        @openPage(new PasswordSuccessfullyChangedPage)
