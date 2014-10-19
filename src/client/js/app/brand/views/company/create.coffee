define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')
  Invites = require('cs!app/common/mongoCollection')

  Layout.extend

    template: require('hbs!./create')

    initialize: ->
      @invites = new Invites()

    onRender: ->
      @renderGrid()

    onCreate: (invitee, callback) ->
      @invites.add(invitee)
      callback()

    renderGrid: ->
      @invitees.show new Grid({
        collection: @invites
        defaultEmptyText: window.RetailTracker.i18n.emptyInvitesGrid
        editable: @
        columns: [
          {
            field: 'email'
            title: window.RetailTracker.i18n.email
            type: 'string'
            placeholder: 'email@example.com'
          }
        ]
      })