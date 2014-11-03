define (require) ->
  'use strict'

  Marionette = require('marionette')
  RegistrationCompleted = require('cs!./completed')

  Marionette.ItemView.extend

    template: require('hbs!./confirm')

    confirm: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.confirm()
      .then =>
        @eventBus.trigger('open:page', new RegistrationCompleted)
      .then null, (err) =>
        @validation.show(err.errors)
