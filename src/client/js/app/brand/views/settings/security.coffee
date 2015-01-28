define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  context = require('cs!app/common/context')
  PasswordSettings = require('cs!app/brand/models/passwordSettings')

  ItemView.extend

    template: require('hbs!./security.hbs')

    initialize: ->
      @model = new PasswordSettings({
        userId: context.get('account.owner._id')
      })

    save: (e) ->
      e.preventDefault()

      @model.save().then =>
        @model.unset('oldPassword')
        @model.unset('password')
        @model.unset('confirmPassword')
        @navigateTo('')

