define (require) ->
  'use strict'

  Marionette = require('marionette')
  Grid = require('util/grid/main')

  Marionette.Layout.extend

    template: require('hbs!./main')

    regions:
      grid: '[data-id="grid"]'

    initialize: (options) ->
      @collection = options.collection

    onCreate: (model, callback) ->
      return callback(model.validationError) if not model.isValid()
      @collection.add(model)
      callback()

    onSave: (model, callback) ->
      return callback(model.validationError) if not model.isValid()
      callback()

    onDelete: (model, callback) ->
      console.log('Server removed item')
      @collection.remove(model)
      callback()

    onShow: ->
      @renderGrid()

    renderGrid: ->
      @grid.show(new Grid({
        collection: @collection
        editable: true
        numerable: true
        onCreate: _.bind(@onCreate, @)
        onSave: _.bind(@onSave, @)
        onDelete: _.bind(@onDelete, @)
        columns: [
          {
            field: 'code'
            title: window.RetailTracker.i18n.code
            type: 'string'
            width: 100
          }
          {
            field: 'name'
            title: window.RetailTracker.i18n.name
            type: 'string'
            width: 250
          }
          {
            field: 'description'
            title: window.RetailTracker.i18n.description
            type: 'string'
          }
        ]
      }))
