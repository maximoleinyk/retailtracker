define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./uom.hbs')
    className: 'page'

    initialize: (options) ->
      @collection = options.collection

    onCreate: (model, callback) ->
      model.create (err, model) =>
        return callback(err) if err
        @collection.add(model)
        callback(null)

    onSave: (model, callback) ->
      model.update (err) ->
        if err then callback(err) else callback(null)

    onDelete: (model, callback) ->
      model.delete (err) =>
        return callback(err) if err
        @collection.remove(model)
        callback(err)

    onCancel: (model, callback) ->
      model.reset()
      callback()

    onRender: ->
      @grid.show(new Grid({
        collection: @collection
        editable: @
        defaultEmptyText: 'Вы еще не создали ни одной единицы измерения'
        columns: [
          {
            field: 'shortName'
            title: i18n.get('shortName')
            type: 'string'
            width: 250
          }
          {
            field: 'fullName'
            title: i18n.get('fullName')
            type: 'string'
          }
        ]
      }))