define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  context = require('cs!app/common/context')
  ProfileSettings = require('cs!app/brand/models/profileSettings')

  ItemView.extend

    template: require('hbs!./profile.hbs')

    initialize: ->
      @model = new ProfileSettings({
        id: context.get('account.owner._id')
        firstName: context.get('account.owner.firstName')
        lastName: context.get('account.owner.lastName')
      })

    save: (e) ->
      e.preventDefault()

      @model.save().then =>
        context.set({
          'account.owner.firstName': @model.get('firstName'),
          'account.owner.lastName': @model.get('lastName')
        })
        @navigateTo('')
