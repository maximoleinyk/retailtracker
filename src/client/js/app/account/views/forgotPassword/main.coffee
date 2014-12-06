define (require) ->
  'use strict'

  Marionette = require('marionette')
  ForgotPasswordSuccessPage = require('cs!./sent')
  Account = require('cs!app/account/models/account')

  Marionette.ItemView.extend

    template: require('hbs!./main.hbs')

    initialize: ->
      @model = new Account()

    sendEmail: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.forgotPassword()
      .then =>
        @eventBus.trigger('open:page', new ForgotPasswordSuccessPage)
      .then null, (err) =>
        @validation.show(err.errors)