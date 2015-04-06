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
            width: 75
          },
          {
            field: 'status'
            title: i18n.get('status')
            width: 250
            url: (model) ->
              '/goods/receive/' + model.id
            formatter: (value, model) ->
              result = i18n.get(value.toLowerCase()) + ' '
              switch (value)
                when 'DRAFT' then result += helpers.dateTime(model.get('created'))
                when 'ENTERED' then result += helpers.dateTime(model.get('entered'))
                else
                  result
              result
          },
          {
            field: 'warehouse'
            title: i18n.get('warehouse')
            url: (model) ->
              '/warehouses/' + model.get('warehouse._id')
            formatter: (warehouse) ->
              warehouse.name
          },
          {
            field: 'assignee'
            title: i18n.get('assignee')
            url: (model) ->
              '/employees/' + model.get('employee._id')
            formatter: (value) ->
              value.firstName + ' ' + value.lastName
          },
          {
            field: 'items'
            title: i18n.get('totalQuantity')
            width: 150
            type: 'number'
            formatter: (value) ->
              (value or []).length
          },
          {
            field: 'currencyCode'
            title: i18n.get('currency')
            width: 90
          },
          {
            field: 'totalPrice'
            title: i18n.get('totalPrice')
            formatter: (value, model) ->
              helpers.amount(value, model.get('currencyCode'))
            type: 'number'
          }
        ]
      })
