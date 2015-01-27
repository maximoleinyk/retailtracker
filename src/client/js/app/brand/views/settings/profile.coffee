define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  context = require('cs!app/common/context')

  ItemView.extend

    template: require('hbs!./profile.hbs')
    binding: true

    save: (e) ->
      e.preventDefault()

      @model.changeProfileSettings()
      .then =>
        context.set({
          'account.owner.firstName': @model.get('firstName'),
          'account.owner.lastName': @model.get('lastName')
        })
        @navigateTo('')
