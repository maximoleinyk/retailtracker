define (require) ->
  'use strict'

  Marionette = require('marionette')
  UserInfo = require('util/userInfo')

  Marionette.ItemView.extend

    template: require('hbs!./profile')
    binding: true

    save: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.changeProfileSettings()
      .then =>
        UserInfo.set({
          firstName: @model.get('firstName')
          lastName: @model.get('lastName')
        })
        @navigateTo('')
      .then null, (err) =>
        @validation.show(err.errors)
