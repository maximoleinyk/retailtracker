define (require) ->
  'use strict'

  BaseController = require('cs!app/common/controller');
  LoginPage = require('cs!./view/login')
  RegistrationPage = require('cs!./view/register')
  RegistrationSuccessPage = require('cs!./view/success')

  BaseController.extend

    login: ->
      @openPage(new LoginPage)

    register: ->
      @openPage(new RegistrationPage)

    success: ->
      @openPage(new RegistrationSuccessPage)
