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
        defaultEmptyText: i18n.get('emptyReceiveGoodsList')
        columns: [
          {
            field: 'number'
            title: i18n.get('number')
            width: 90
          },
          {
            field: 'status'
            title: i18n.get('status')
            width: 150
          },
          {
            field: 'warehouse'
            title: i18n.get('warehouse')
            formatter: (warehouse) ->
              warehouse.name
          },
          {
            field: 'enterDate'
            title: i18n.get('enterDate')
            formatter: (value) ->
              helpers.date(value)
            width: 180
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
            field: 'totalAmount'
            title: i18n.get('totalAmount')
            formatter: (value, model) ->
              model.get('uom') + ' ' + helpers.amount(value)
            type: 'number'
          }
        ]
      })
