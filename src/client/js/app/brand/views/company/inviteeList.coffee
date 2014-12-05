define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')

  Layout.extend

    template: require('hbs!./inviteeList.hbs')

    onRender: ->
      @invitees.show new Grid({
        collection: @options.collection
        defaultEmptyText: window.RetailTracker.i18n.emptyInvitesGrid
        withoutHeader: true
        editable: @
        skipInitialAutoFocus: true,
        columns: [
          {
            field: 'firstName'
            type: 'string'
            placeholder: window.RetailTracker.i18n.firstName
            width: 180
          },
          {
            field: 'email'
            type: 'email'
            placeholder: window.RetailTracker.i18n.emailExampleCom
          }
        ]
      })

    updateList: ->
      @model.set('invitees', @options.collection.toJSON())

    onCreate: (invitee, callback) ->
      return callback({ email: window.RetailTracker.i18n.invalidEmail }) if not invitee.get('email')
      invitee.commit()
      @options.collection.add(invitee)
      @updateList()
      callback()

    onSave: (invitee, callback) ->
      return callback({ email: window.RetailTracker.i18n.invalidEmail }) if not invitee.get('email')
      invitee.commit()
      @updateList()
      callback()

    onCancel: (invitee, callback) ->
      invitee.reset()
      callback()

    onDelete: (invitee, callback) ->
      @options.collection.remove(invitee)
      @updateList()
      callback()