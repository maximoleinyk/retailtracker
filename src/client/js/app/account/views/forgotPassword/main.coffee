define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  ForgotPasswordSuccessPage = require('cs!./sent')
  Account = require('cs!app/account/models/account')

  ItemView.extend

    template: require('hbs!./main.hbs')
    className: 'page page-box'

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