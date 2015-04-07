define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  i18n = require('cs!app/common/i18n')
  helpers = require('app/common/helpers')
  numeral = require('numeral')

  Layout.extend

    template: require('hbs!./list.hbs')
    className: 'page'

    onRender: ->
      @grid.show new Grid({
        collection: @collection
        defaultEmptyText: i18n.get('warehouseItemsGridEmptyLabel')
        columns: [
          {
            field: 'nomenclature'
            title: i18n.get('nomenclature')
            url: (model) ->
              '/nomenclature/' + model.get('nomenclature._id')
            formatter: (value) ->
              value.name
          },
          {
            field: 'warehouse'
            title: i18n.get('warehouse')
            url: (model) ->
              '/warehouses/' + model.get('warehouse._id')
            formatter: (value) ->
              value.name
          },
          {
            field: 'currency'
            title: i18n.get('currency')
            formatter: (value) ->
              value.name
            width: 150
          }
          {
            field: 'quantity'
            title: i18n.get('quantity')
            type: 'number'
            width: 100
          },
          {
            field: 'price'
            title: i18n.get('price')
            type: 'number'
            formatter: (value) ->
              helpers.money(value)
            width: 150
          },
          {
            field: 'non_existing'
            title: i18n.get('sum')
            type: 'number'
            formatter: (empty, model) ->
              helpers.money(numeral(model.get('price')).multiply(model.get('quantity')).value())
            width: 150
          }
        ]
      })
