define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  LoginPage = require('cs!./views/login')
  RegistrationPage = require('cs!./views/registration/main')
  RegistrationApprovePage = require('cs!./views/registration/confirm')
  ForgotPasswordPage = require('cs!./views/forgotPassword/main')
  PasswordChangePage = require('cs!./views/forgotPassword/change')
  ConfirmCompanyInvitePage = require('cs!./views/companyInvite/main')
  Account = require('cs!./models/account')
  Invite = require('cs!./models/invite')
  Security = require('cs!./models/security')
  ForgotPassword = require('cs!./models/forgotPassword')
  ChangeForgottenPassword = require('cs!./models/changeForgottenPassword')
  Company = require('cs!app/brand/models/company')

  Controller.extend

    login: ->
      @openPage(new LoginPage({
        model: new Security
      }))

    registerAccount: ->
      @openPage(new RegistrationPage({
        model: new Account
      }))

    forgotPassword: ->
      @openPage new ForgotPasswordPage({
        model: new ForgotPassword
      })

    confirmAccountRegistration: (link) ->
      @openPage new RegistrationApprovePage({
        model: new Invite({
          link: link
        })
      })

    changeForgottenPassword: (key) ->
      @openPage new PasswordChangePage({
        model: new ChangeForgottenPassword({
          key: key
        })
      })

    confirmCompanyInvite: (key) ->
      company = new Company({
        key: key
      })

      company.loadInvitedCompanyDetails().then =>
        @openPage new ConfirmCompanyInvitePage({
          company: company
          model: new Invite({
            key: key
            hasAccount: company.get('hasAccount')
          })
        })
      .catch =>
        @navigateTo('login')
