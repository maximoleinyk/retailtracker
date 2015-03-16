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

      if @model.isNew()
        columns.push({
          id: uuid()
          name: i18n.get('costPrice')
          type: 'COSTPRICE'
          amount: 0
        })

      @columns = new Collection(columns)

    templateHelpers: ->
      isNew: @model.isNew()
      activated: @model.isActivated()

    onRender: ->
      @renderAssigneeSelect()
      @renderGrid()

    currencyFormatter: (obj) =>
      if obj.text then obj.text else obj.name

    renderAssigneeSelect: ->
      currencyObject = @model.get('currency')
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
          callback(currencyObject)
      })
      if @model.get('currency')
        @model.set('currency', currencyObject._id, {silent: true})

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
              model.set('type', object.id)
            width: 250
          },
          {
            field: 'amount'
            title: i18n.get('value')
            type: 'number'
          }
        ],
        isActionCellVisible: (model) =>
          model.get('id') isnt @columns.indexOf(model) isnt 0
      })

    onCreate: (model, callback) ->
      return callback({ name: i18n.get('nameShouldBeSpecified') }) if !model.has('name')
      return callback({ amount: i18n.get('valueShouldBeNumeric')}) if !model.has('amount')
      @columns.add(model)
      model.set('id', uuid())
      @model.set('columns', @columns.toJSON())
      @model.validate({sync: true})
      callback()

    onDelete: (model, callback) ->
      @columns.remove(model)
      callback()

    activate: ->
      @model.activate().then =>
        @render()

    delete: ->
      @model.destroy().then =>
        @navigateTo('/templates')

    submit: ->
      @model.save().then =>
        @navigateTo('/templates/' + @model.id)
