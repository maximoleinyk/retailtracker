define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  ProductGroups = require('cs!app/company/collections/productGroups')
  Promise = require('rsvp').Promise
  _ = require('underscore')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./productGroups.hbs')
    className: 'page'

    initialize: (options) ->
      @collection = options.collection
      @data = []

    onCreate: (model, callback) ->
      model.save()
      .then =>
        @collection.add(model)
        callback()
      .catch (model) =>
        callback(model.get('errors'))

    onSave: (model, callback) ->
      model.save()
      .then ->
        callback()
      .catch (model) =>
        callback(model.get('errors'))

    onDelete: (id, callback) ->
      promises = _.map _.difference(@collection.pluck('id'), @getAvailableGroups(id).pluck('id')), (id) =>
        @collection.get(id)?.destroy()
      Promise.all(promises).then(callback).catch(callback)

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
        defaultEmptyText: i18n.get('defaultProductGroupGridText')
        columns: [
          {
            field: 'name'
            title: i18n.get('name')
            type: 'string'
            width: 200
          }
          {
            field: 'parentGroup'
            title: i18n.get('parentGroup')
            placeholder: i18n.get('selectGroup')
            type: 'select'
            data: (model) =>
              if (model.isNew())
                return @getData(@options.collection)
              else
                return @getData(@getAvailableGroups(model))
            formatter: (id) =>
              if id then @collection.get(id)?.get('name') else ''
            formatResult: (modelJSON) =>
              if modelJSON.text then modelJSON.text else @collection.get(modelJSON.parentGroup)?.get('name')
            onSelection: (object, model) ->
              model.set('parentGroup', object.id)
            width: 300
          }
          {
            field: 'description'
            title: i18n.get('description')
            type: 'string'
          }
        ]
      })
