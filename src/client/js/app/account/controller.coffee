define (require) ->
  'use strict'

  BaseController = require('cs!app/common/controller');
  LoginPage = require('cs!./view/login')
  RegistrationPage = require('cs!./view/register')
  RegistrationSuccessPage = require('cs!./view/success')
  RegistrationApprovePage = require('cs!./view/approve')
  Invite = require('cs!./model/invite')

  BaseController.extend

    login: ->
      @openPage(new LoginPage)

    register: ->
      @openPage(new RegistrationPage)

    success: ->
      @openPage(new RegistrationSuccessPage)

    approve: (inviteKey) ->
      invite = new Invite({id: inviteKey})

      invite.fetch()
      .then ->
        @showPage(new RegistrationApprovePage({model: invite}))
      .then =>
        @login()


