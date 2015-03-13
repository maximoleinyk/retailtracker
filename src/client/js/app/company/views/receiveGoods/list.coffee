define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  i18n = require('cs!app/common/i18n')
  helpers = require('app/common/helpers')

  Layout.extend

    template: require('hbs!./list.hbs')
    className: 'page'

    onRender: ->
      @grid.show new Grid({
        collection: @collection
        defaultEmptyText: i18n.get('thereAreNoOrders')
        columns: [
          {
            field: 'number'
            title: i18n.get('number')
          },
          {
            field: 'created'
            title: i18n.get('creationDate')
            formatter: (value) ->
              helpers.date(value)
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
            field: 'receivingDate'
            title: i18n.get('receivingDate')
            formatter: (value) ->
              helpers.date(value)
          },
          {
            field: 'warehouseItems'
            title: i18n.get('itemsCount')
            formatter: (value, model) ->
              model.get('warehouseItems').length
            type: 'number'
            width: 150
          },
          {
            field: 'totalAmount'
            title: i18n.get('totalAmount')
            formatter: (value, model) ->
              model.get('uom') + ' ' + helpers.amount(value)
            type: 'number'
          }
        ]
      })
