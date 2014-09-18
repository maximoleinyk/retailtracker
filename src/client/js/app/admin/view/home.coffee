define (require) ->
  'use strict'

  Marionette = require('marionette')
  Grid = require('util/grid/main')
  numeral = require('numeral')

  Marionette.Layout.extend

    template: require('hbs!./home')

    regions:
      container: '[data-id="grid-wrapper"]'

    onRender: ->
      this.container.show(new Grid({
        collection: this.options.collection,
        numerable: true,
        editable: true,
        columns: [
          {
            field: 'product'
            title: 'Позиция'
            type: 'select',
            url: '/products/search'
            formatter: (data) ->
              data?.productName
            onSelection: (object, model) ->
              model.set({
                price: object.price
                count: 1
              })
          }
          {
            field: 'count'
            title: 'Кол-во'
            type: 'number'
            width: 100
          }
          {
            field: 'price'
            title: 'Цена'
            type: 'number'
            width: 120
            formatter: (value) ->
              numeral(value).format('0,0.00')
          }
        ]
      }))
