define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')
  ProductGroups = require('cs!app/company/collections/productGroups')
  _ = require('underscore')

  Layout.extend

    template: require('hbs!./currencies')
    className: 'container'

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
      @data = @getData(@getAvailableGroups())
      @renderGrid()

    getAvailableGroups: (model) ->
      restrictedModels = []
      queue = if model then [model] else []
      collect = =>
        group = queue.shift()
        restrictedModels.push(group)
        _.each @collection.where({parentGroup: group.id}), (child) ->
          queue.push(child)
      collect() while queue.length isnt 0

      result = new ProductGroups(@collection.models)
      result.remove(restrictedModels)
      result

    getData: (collection) ->
      collection.map (model) ->
        id: model.id
        text: model.get('name')

    renderGrid: ->
      @grid.show new Grid({
        collection: @collection
        editable: @
        defaultEmptyText: window.RetailTracker.i18n.defaultProductGroupGridText
        columns: [
          {
            field: 'name'
            title: window.RetailTracker.i18n.name
            type: 'string'
            width: 200
          }
          {
            field: 'parentGroup'
            title: window.RetailTracker.i18n.parentGroup
            placeholder: window.RetailTracker.i18n.selectParent
            type: 'select'
            data: @data
            formatter: (value) ->
              value
            formatResult: (json) ->
              if json.text then json.text else json.name
            onSelection: (object, model) ->
              model.set('parentGroup', object.id)
            width: 300
          }
          {
            field: 'description'
            title: window.RetailTracker.i18n.description
            type: 'string'
          }
        ]
      })