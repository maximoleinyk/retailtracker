define (require) ->
  'use strict'

  Marionette = require('marionette')
  RegistrationSuccessPage = require('cs!./sent')
  Account = require('app/account/models/account')

  Marionette.ItemView.extend

    template: require('hbs!./main')

    initialize: ->
      @model = new Account()

    register: (e) ->
      e.preventDefault()

      originButtonLabel = @ui.$registerButton.text()

      @validation.reset()
      @ui.$registerButton.text('Регистрация...').attr('disabled', true)

      @model.register()
      .then =>
        @eventBus.trigger('open:page', new RegistrationSuccessPage)
      .then null, (err) =>
        @validation.show(err.errors)
        @ui.$registerButton.text(originButtonLabel).removeAttr('disabled')

