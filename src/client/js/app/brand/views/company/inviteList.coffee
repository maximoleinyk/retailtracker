define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')
  Invites = require('cs!app/account/collections/invites')

  Layout.extend

    template: require('hbs!./inviteList')

    initialize: ->
      @collection = new Invites()

    onRender: ->
      @renderGrid()

    renderGrid: ->
      @invitees.show new Grid({
        collection: @collection
        defaultEmptyText: window.RetailTracker.i18n.emptyInvitesGrid
        withoutHeader: true
        editable: @
        columns: [
          {
            field: 'email'
            type: 'email'
            placeholder: 'email@example.com'
          }
        ]
      })

    updateInvitees: ->
      @model.set 'invitees', @collection.map (model) ->
        model.get('email')

    onCreate: (invitee, callback) ->
      return callback({ email: window.RetailTracker.i18n.invalidEmail }) if not invitee.get('email')
      invitee.commit()
      @collection.add(invitee)
      @updateInvitees()
      callback()

    onSave: (invitee, callback) ->
      return callback({ email: window.RetailTracker.i18n.invalidEmail }) if not invitee.get('email')
      invitee.commit()
      @updateInvitees()
      callback()

    onCancel: (invitee, callback) ->
      invitee.reset()
      callback()

    onDelete: (invitee, callback) ->
      @collection.remove(invitee)
      @updateInvitees()
      callback()