define (require) ->
  'use strict'

  BaseController = require('cs!app/common/controller');
  LoginPage = require('cs!./view/login')
  RegistrationPage = require('cs!./view/register')

  BaseController.extend

    login: ->
      @openPage(new LoginPage)

    register: ->
      @openPage(new RegistrationPage)

    success: ->
      @openPage(new SuccessRegistration)
