define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  context = require('cs!app/common/context')

  ItemView.extend

    template: require('hbs!./profile.hbs')
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
