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
      console.log('Created on server!')
      @options.collection.add(model)
      callback()

    onSave: (model, callback) ->
      console.log('Saved on server!')
      callback()

    onShow: ->
      @container.show(new Grid({
        collection: @options.collection
        numerable: true
        editable: true
        onCreate: _.bind(@onCreate, @)
        onSave: _.bind(@onSave, @)
        columns: [
          {
            field: 'product'
            title: 'Позиция'
            type: 'select'
            url: '/products/search'
            formatter: (value, model) ->
              model.get('productName')
            formatResult: (json) ->
              json?.productName
            onSelection: (object, model) ->
              model.set({
                price: object.price
                productName: object.productName
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
