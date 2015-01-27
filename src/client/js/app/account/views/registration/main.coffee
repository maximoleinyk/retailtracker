define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  RegistrationSuccessPage = require('cs!./sent')
  Account = require('cs!app/account/models/account')

  ItemView.extend

    template: require('hbs!./main.hbs')
    className: 'page page-box'

    initialize: ->
      @model = new Account()

    register: (e) ->
      e.preventDefault()

      originButtonLabel = @ui.$registerButton.text()

      @ui.$registerButton.text('Регистрация...').attr('disabled', true)

      @model.register()
      .then =>
        @eventBus.trigger('open:page', new RegistrationSuccessPage)
      .catch =>
        @ui.$registerButton.text(originButtonLabel).removeAttr('disabled')

