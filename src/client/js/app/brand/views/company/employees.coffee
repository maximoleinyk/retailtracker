define (require) ->
  'use strict'

  _ = require('underscore')
  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./employees.hbs')
    className: 'page'

    templateHelpers: ->
      companyName: @model.get('name')

    onRender: ->
      @grid.show new Grid({
        collection: @options.collection
        columns: [
          {
            field: 'firstName'
            title: i18n.get('firstName')
          }
          {
            field: 'lastName'
            title: i18n.get('lastName')
          }
          {
            field: 'email'
            title: i18n.get('email')
          }
          {
            field: 'phoneNumber'
            title: i18n.get('phoneNumber')
          }
          {
            field: 'role.name'
            title: i18n.get('role')
            formatter: (value) ->
              i18n.get(value.toLowerCase())
          }
          {
            field: 'address'
            title: i18n.get('address')
          }
          {
            type: 'button'
            buttonIcon: 'fa fa-remove'
            buttonTypeClass: 'btn-link'
            action: (e, employee) =>
              @model.get('employees').splice(@model.get('employees').indexOf(employee._id), 1)
              @model.update()
            width: 50
          }
        ]
        isActionCellVisible: (employee) =>
          employee.get('role.name') isnt 'BOSS'
      })
