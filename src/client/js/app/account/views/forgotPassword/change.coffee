define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  PasswordSuccessfullyChanged = require('cs!./success')

  ItemView.extend

    template: require('hbs!./change.hbs')
    className: 'page page-box'

    change: (e) ->
      e.preventDefault()

      @model.changeForgottenPassword()
      .then =>
        @eventBus.trigger('open:page', new PasswordSuccessfullyChanged)
