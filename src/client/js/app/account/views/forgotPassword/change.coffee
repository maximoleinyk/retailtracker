define (require) ->
  'use strict'

  Marionette = require('marionette')
  PasswordSuccessfullyChanged = require('cs!./success')

  Marionette.ItemView.extend

    template: require('hbs!./change.hbs')

    change: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.changeForgottenPassword()
      .then =>
        @eventBus.trigger('open:page', new PasswordSuccessfullyChanged)
      .then null, (err) =>
        @validation.show(err.errors)
