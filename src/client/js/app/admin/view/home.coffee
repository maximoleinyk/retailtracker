define (require) ->
  'use strict'

  Marionette = require('marionette')
  Grid = require('util/grid/main')
  Products = require('cs!app/admin/collection/products')

  Marionette.Layout.extend

    template: require('hbs!./home')

    regions:
      container: '[data-id="grid-wrapper"]'

    onShow: ->
      this.container.show(new Grid({
        collection: new Products(),
        numerable: true,
        editable: true,
        columns: [
          {
            field: 'product'
            title: 'Позиция'
            type: 'select',
            format: (value, model) -> model.get('productName')
          }
          {
            field: 'amount'
            title: 'Кол-во'
            type: 'number'
          }
          {
            field: 'price'
            title: 'Цена'
            type: 'number'
          }
        ]
      }))
