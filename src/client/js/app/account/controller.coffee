define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  LoginPage = require('cs!./views/login')
  RegistrationPage = require('cs!./views/registration/main')
  RegistrationApprovePage = require('cs!./views/registration/confirm')
  ForgotPasswordPage = require('cs!./views/forgotPassword/main')
  PasswordChangePage = require('cs!./views/forgotPassword/change')
  Account = require('cs!./models/account')
  Company = require('cs!app/brand/models/company')
  ConfirmCompanyInvitePage = require('cs!./views/companyInvite/main')

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
      })
      @openPage new RegistrationApprovePage({
        model: account
      })

    changeForgottenPassword: (changeKey) ->
      account = new Account({
        key: changeKey
      })
      @openPage new PasswordChangePage({
        model: account
      })

    confirmCompanyInvite: (inviteKey) ->
      company = new Company({
        key: inviteKey
      })

      company.loadInvitedCompanyDetails()
      .then =>
        @openPage new ConfirmCompanyInvitePage({
          company: company
          model: new Account({
            key: inviteKey
          })
        })
      .catch =>
        @navigateTo('login')
