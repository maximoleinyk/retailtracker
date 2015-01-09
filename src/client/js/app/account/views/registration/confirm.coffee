define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  RegistrationCompleted = require('cs!./completed')

  ItemView.extend

    template: require('hbs!./confirm.hbs')
    className: 'page page-box'

    confirm: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.confirm()
      .then =>
        @eventBus.trigger('open:page', new RegistrationCompleted)
      .catch (err) =>
        @validation.show(err.errors)
