define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')

  Layout.extend

    template: require('hbs!./employeeList')

    onRender: ->
      @employees.show new Grid({
        collection: @options.collection
        defaultEmptyText: window.RetailTracker.i18n.emptyInvitesGrid
        withoutHeader: true
        editable: @
        initialAutoFocus: true,
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

    onCreate: (employee, callback) ->
      return callback({ email: window.RetailTracker.i18n.invalidEmail }) if not employee.get('email')
      employee.commit()
      @options.collection.add(employee)
      @updateList()
      callback()

    onSave: (employee, callback) ->
      return callback({ email: window.RetailTracker.i18n.invalidEmail }) if not employee.get('email')
      employee.commit()
      @updateList()
      callback()

    onCancel: (employee, callback) ->
      employee.reset()
      callback()

    onDelete: (employee, callback) ->
      @options.collection.remove(employee)
      @updateList()
      callback()