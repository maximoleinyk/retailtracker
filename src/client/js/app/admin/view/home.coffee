define (require) ->
  'use strict'

  Marionette = require('marionette')
  Grid = require('util/grid/main')
  Products = require('cs!app/admin/collection/products')

  Marionette.Layout.extend

    template: require('hbs!./home')

    regions:
      container: '[data-hook="grid-wrapper"]'

    onShow: ->
      this.container.show(new Grid({
        collection: new Products(),
        numerable: true,
        columns:
          product:
            title: 'Позиция'
            type: 'string'
          amount:
            title: 'Кол-во'
            type: 'number'
          price:
            title: 'Цена'
            type: 'number'
            formatter: (value) -> value
      }))
