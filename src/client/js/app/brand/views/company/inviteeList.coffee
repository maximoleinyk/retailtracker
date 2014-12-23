define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./inviteeList.hbs')

    onRender: ->
      @invitees.show new Grid({
        collection: @options.collection
        defaultEmptyText: i18n.get('emptyInvitesGrid')
        withoutHeader: true
        editable: @
        skipInitialAutoFocus: true,
        columns: [
          {
            field: 'firstName'
            type: 'string'
            placeholder: i18n.get('firstName')
            width: 180
          },
          {
            field: 'email'
            type: 'email'
            placeholder: i18n.get('emailExampleCom')
          }
        ]
      })

    updateList: ->
      @model.set('invitees', @options.collection.toJSON())

    onCreate: (invitee, callback) ->
      return callback({ email: i18n.get('invalidEmail') }) if not invitee.get('email')
      invitee.commit()
      @options.collection.add(invitee)
      @updateList()
      callback()

    onSave: (invitee, callback) ->
      return callback({ email: i18n.get('invalidEmail') }) if not invitee.get('email')
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