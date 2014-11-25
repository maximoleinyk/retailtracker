define (require) ->
  'use strict'

  Marionette = require('marionette')
  context = require('cs!app/common/context')

  Marionette.ItemView.extend

    template: require('hbs!./profile')
    binding: true

    save: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.changeProfileSettings()
      .then =>
        context.set({
          'owner.firstName': @model.get('firstName'),
          'owner.lastName': @model.get('lastName')
        })
        @navigateTo('')
      .then null, (err) =>
        @validation.show(err.errors)
