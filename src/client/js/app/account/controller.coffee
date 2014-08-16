define (require) ->
  'use strict'

  BaseController = require('cs!app/common/controller');
  LoginPage = require('cs!./view/login')
  RegistrationPage = require('cs!./view/register')
  RegistrationSuccessPage = require('cs!./view/success')
  RegistrationApprovePage = require('cs!./view/approve')
  ForgotPasswordPage = require('cs!./view/forgot')
  Invite = require('cs!./model/invite')

  BaseController.extend

    login: ->
      @openPage(new LoginPage)

    register: ->
      @openPage(new RegistrationPage)

    success: ->
      @openPage(new RegistrationSuccessPage)

    forgot: ->
      @openPage(new ForgotPasswordPage)

    approve: (inviteKey) ->
      invite = new Invite({id: inviteKey})
      invite.fetch()
      .then =>
        @openPage(new RegistrationApprovePage({model: invite}))
      .then null, =>
        @eventBus.trigger('router:navigate', 'account/login')
        @login()


