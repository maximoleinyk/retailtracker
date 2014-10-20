define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')
  Invites = require('cs!app/common/mongoCollection')

  Layout.extend

    template: require('hbs!./create')

    initialize: ->
      @inviteesCollection = new Invites()

    onRender: ->
      @renderGrid()
      @renderSelect()

    renderSelect: ->
      @ui.$select.select2()

    cancel: ->
      @navigate('')

    onSubmit: (e) ->
      e.preventDefault()

      @model.set('invitees', @inviteesCollection.toJSON())
      @model.create()
      .then =>
        @navigate('')
      .then null, (err) =>


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
      @inviteesCollection.add(invitee)
      callback()

    onDelete: (invitee, callback) ->
      @inviteesCollection.remove(invitee)
      callback()