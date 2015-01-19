define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  i18n = require('cs!app/common/i18n')
  suggestionTemplate = require('hbs!./suggestionTemplate.hbs')
  avatar = require('cs!app/common/avatar')

  Layout.extend

    template: require('hbs!./inviteeList.hbs')

    onRender: ->
      @invitees.show new Grid({
        collection: @options.collection
        defaultEmptyText: i18n.get('emptyInvitesGrid')
        editable: @
        skipInitialAutoFocus: true,
        columns: [
          {
            field: 'firstName'
            title: i18n.get('firstName')
            type: 'string'
            placeholder: i18n.get('firstName')
            width: 180
          },
          {
            field: 'email'
            title: i18n.get('email')
            type: 'autocomplete'
            url: '/employees/fetch'
            queryParams:
              limit: 5
            placeholder: i18n.get('emailExampleCom')
            display: (employee) ->
              employee.email
            suggestionTemplate: (employee) ->
              suggestionTemplate(employee, {
                helpers:
                  avatarUrl: ->
                    avatar(employee.email)
              })
          },
          {
            field: 'role'
            title: i18n.get('role')
            placeholder: i18n.get('selectRole')
            type: 'select'
            selectFirst: true
            data: =>
              @options.roles.map (model) ->
                id: model.id
                text: i18n.get(model.get('name').toLowerCase())
            formatter: (id) =>
              if id
                return i18n.get(@options.roles.get(id).get('name').toLowerCase())
              else
                return ''
            formatResult: (object) =>
              if object.text
                return object.text
              else
                return i18n.get(@options.roles.get(object.id).get('name').toLowerCase())
            onSelection: (object, model) ->
              model.set('role', object.id)
            width: 220
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
