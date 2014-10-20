define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')
  Invites = require('cs!app/account/collections/invites')

  Layout.extend

    template: require('hbs!./inviteList')

    initialize: ->
      @inviteesCollection = new Invites()

    onRender: ->
      @renderGrid()

    renderGrid: ->
      @invitees.show new Grid({
        collection: @inviteesCollection
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

    onCreate: (invitee, callback) ->
      return callback({ email: window.RetailTracker.i18n.invalidEmail }) if not invitee.get('email')
      invitee.commit()
      @inviteesCollection.add(invitee)
      callback()

    onSave: (invitee, callback) ->
      return callback({ email: window.RetailTracker.i18n.invalidEmail }) if not invitee.get('email')
      invitee.commit()
      callback()

    onCancel: (invitee, callback) ->
      invitee.reset()
      callback()

    onDelete: (invitee, callback) ->
      @inviteesCollection.remove(invitee)
      callback()