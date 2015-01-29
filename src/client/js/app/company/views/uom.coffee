define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./uom.hbs')
    className: 'page'

    onCreate: (model, callback) ->
      model.save()
      .then =>
        @options.collection.add(model)
        callback()
      .catch (model) =>
        callback(model.get('errors'))

    onSave: (model, callback) ->
      model.save()
      .then ->
        callback()
      .catch (model) ->
        callback(model.get('errors'))

    onDelete: (model, callback) ->
      model.destroy()
      .then =>
        callback()
      .catch (model) =>
        callback(model.get('errors'))

    onCancel: (model, callback) ->
      model.reset()
      callback()

    onRender: ->
      @grid.show(new Grid({
        collection: @options.collection
        editable: @
        defaultEmptyText: i18n.get('uomEmptyListMessage')
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
