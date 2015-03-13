define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  i18n = require('cs!app/common/i18n')
  select = require('select')
  Grid = require('app/common/grid/main')
  Collection = require('cs!app/common/collection')
  helpers = require('app/common/helpers')
  _ = require('underscore')
  uuid = require('cs!app/common/uuid')

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-halves page-2thirds'

    initialize: ->
      @types = ['COSTPRICE', 'PERCENT', 'FIXED']
      columns = @model.get('columns')
      columns.push({
        id: 'costprice'
        name: i18n.get('costPrice')
        type: 'FIXED'
        value: 0
      })
      @columns = new Collection(columns)

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
            field: 'name'
            title: i18n.get('name')
            type: 'string'
            width: 250
          },
          {
            field: 'type'
            title: i18n.get('marginType')
            placeholder: i18n.get('selectType')
            type: 'select'
            selectFirst: true
            data: [
              {
                id: 'PERCENT'
                text: i18n.get('percent')
              },
              {
                id: 'FIXED'
                text: i18n.get('fixed')
              }
            ]
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
              model.set({
                id: uuid()
                type: object.id
              })
            width: 250
          },
          {
            field: 'amount'
            title: i18n.get('value')
            type: 'number'
          }
        ],
        isActionCellVisible: (model) ->
          model.get('id') isnt 'costprice'
      })

    onCreate: (model, callback) ->
      return callback({ name: i18n.get('nameShouldBeSpecified') }) if !model.has('name')
      return callback({ value: i18n.get('valueShouldBeNumeric')}) if !model.has('name')
      @columns.add(model)
      @model.set('columns', @columns.toJSON())
      @model.validate({sync: true})
      callback()

    onDelete: (model, callback) ->
      @columns.remove(model)
      callback()

    submit: ->
      @model.save().then =>
        @navigateTo('/templates')
