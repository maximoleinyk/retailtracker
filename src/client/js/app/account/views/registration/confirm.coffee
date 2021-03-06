define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  RegistrationCompleted = require('cs!./completed')

  ItemView.extend

    template: require('hbs!./confirm.hbs')
    className: 'page page-box'

    confirm: (e) ->
      e.preventDefault()

      @model.confirmAccountRegistration().then =>
        @openPage(new RegistrationCompleted)
