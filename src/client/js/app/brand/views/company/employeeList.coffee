define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')

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
          }
        ],
        isActionCellVisible: (model) ->
          model.id isnt context.get('owner.id')
      })