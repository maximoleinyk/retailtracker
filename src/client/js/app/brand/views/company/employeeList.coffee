define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')
  DeleteButtonCell = require('cs!./deleteButtonCell')

  Layout.extend

    template: require('hbs!./employeeList')

    onRender: ->
      @employees.show new Grid({
        collection: @options.collection
        withoutHeader: true
        columns: [
          {
            field: 'firstName'
            type: 'string'
            formatter: (value, model) ->
              model.get('firstName') + ' ' + model.get('lastName')
          },
          {
            field: 'email'
            type: 'email'
          },
          {
            cell: DeleteButtonCell
            type: 'custom'
            width: 60
            options:
              employees: @collection
              company: @model
          }
        ]
      })