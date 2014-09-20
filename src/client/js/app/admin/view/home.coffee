define (require) ->
  'use strict'

  Marionette = require('marionette')
  Grid = require('util/grid/main')
  numeral = require('numeral')

  Marionette.Layout.extend

    template: require('hbs!./home')

    regions:
      container: '[data-id="grid-wrapper"]'

    onCreate: (model, callback) ->
      @options.collection.add(model)
      callback()

    onShow: ->
      @container.show(new Grid({
        collection: @options.collection
        numerable: true
        editable: true
        onCreate: _.bind(@onCreate, @)
        columns: [
          {
            field: 'product'
            title: 'Позиция'
            type: 'select'
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
            width: 180
            attributes:
              readonly: true
            formatter: (value) ->
              numeral(value).format('0,0.00')
          }
        ]
      }))
