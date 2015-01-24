define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./list.hbs')
    className: 'page'

    onRender: ->
      @grid.show(new Grid({
        collection: @options.collection
        defaultEmptyText: i18n.get('warehouseEmptyList')
        columns: [
          {
            field: 'name'
            title: i18n.get('name')
            url: (model) ->
              '/warehouses/' + model.id
          },
          {
            field: 'assignee'
            title: i18n.get('assignee')
            formatter: (value) ->
              value.firstName + ' ' + value.lastName
            url: (model) ->
              '/employees/' + model.id
          },
          {
            field: 'address'
            title: i18n.get('address')
          },
          {
            field: 'description'
            title: i18n.get('description')
          }
        ]
      }))
