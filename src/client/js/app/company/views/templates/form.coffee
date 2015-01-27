define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  i18n = require('cs!app/common/i18n')
  select = require('select')
  Grid = require('app/common/grid/main')
  Collection = require('cs!app/common/collection')
  helpers = require('app/common/helpers')
  _ = require('underscore')

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-halves'

    initialize: ->
      @types = ['PERCENT', 'FIXED']
      @columns = new Collection(@model.get('columns'))

    templateHelpers: ->
      isNew: @model.isNew()

    onRender: ->
      @renderAssigneeSelect()
      @renderGrid()

    currencyFormatter: (obj) =>
      if obj.text then obj.text else obj.name

    renderAssigneeSelect: ->
      select(@ui.$currencySelect, {
        id: (uom) ->
          return uom._id
        ajax:
          url: '/currency/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @currencyFormatter
        formatResult: @currencyFormatter
        initSelection: (element, callback) =>
          callback(@model.get('currency'))
      })
      @ui.$currencySelect.select2('val', @model.get('currency')) if @model.get('currency')

    renderGrid: ->
      @columnWrapper.show new Grid({
        collection: @columns
        defaultEmptyText: i18n.get('emptyPriceListTemplateColumnsText')
        editable: @
        skipInitialAutoFocus: true
        columns: [
          {
            field: 'type'
            title: i18n.get('marginType')
            placeholder: i18n.get('selectType')
            type: 'select'
            selectFirst: true
            data: =>
              @types.map (value) ->
                id: value
                text: i18n.get(value.toLowerCase())
            formatter: (value) =>
              if value
                return i18n.get(value.toLowerCase())
              else
                return value
            formatResult: (object) =>
              if object.text
                return object.text
              else
                return i18n.get(object.id.toLowerCase())
            onSelection: (object, model) ->
              model.set('type', object.id)
            width: 250
          },
          {
            field: 'amount'
            title: i18n.get('value')
            type: 'number'
          }
        ]
      })

    onCreate: (model, callback) ->
      @columns.add(model)
      callback()

    onDelete: (model, callback) ->
      @columns.remove(model)
      callback()

    submit: (e) ->
      e.preventDefault()

      @model.set('columns', @columns.toJSON())
      @model.save().then =>
        @navigateTo('/templates')
