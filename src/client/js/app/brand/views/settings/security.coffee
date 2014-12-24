define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')

  ItemView.extend

    template: require('hbs!./security.hbs')

    save: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.changeSecuritySettings()
      .then =>
        @model.unset('oldPassword')
        @model.unset('password')
        @model.unset('confirmPassword')
        @navigateTo('')
      .then null, (err) =>
        @validation.show(err.errors)

