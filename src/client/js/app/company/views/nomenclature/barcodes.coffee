define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  Collection = require('cs!app/common/collection')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./barcodes.hbs')

    initialize: ->
      @collection = new Collection(@model.get('barcodes'), {parse: true})

    onRender: ->
      @wrapper.show new Grid({
        collection: @collection
        withoutHeader: true
        columns: [
          {
            field: 'value'
            placeholder: i18n.get('selectBarcode')
            type: 'select'
            data: [
              {
                id: 'EAN8'
                text: 'EAN8'
              },
              {
                id: 'EAN13'
                text: 'EAN13'
              }
            ]
            formatter: (value) =>
              value
            formatResult: (modelJSON) =>
              modelJSON.text
            width: 175
          },
          {
            field: 'type'
            type: 'string'
          }
        ]
        editable: @
        skipInitialAutoFocus: true
      })

    update: ->
      @model.set('barcodes', @collection.toJSON())

    onCreate: (barcode, callback) ->
      return callback({ value: i18n.get('enterValue') }) if not barcode.get('value')
      barcode.commit()
      @collection.add(barcode)
      @update()
      callback()

    onSave: (barcode, callback) ->
      return callback({ value: i18n.get('enterValue') }) if not barcode.get('value')
      barcode.commit()
      @update()
      callback()

    onCancel: (barcode, callback) ->
      barcode.reset()
      callback()

    onDelete: (barcode, callback) ->
      @collection.remove(barcode)
      @update()
      callback()