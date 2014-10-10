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
      model.create (err, model) =>
        return callback(err) if err
        @collection.add(model)
        callback(null)

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
        onCreate: _.bind(@onCreate, @)
        onSave: _.bind(@onSave, @)
        onDelete: _.bind(@onDelete, @)
        columns: [
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
