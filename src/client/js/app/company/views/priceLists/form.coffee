define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  i18n = require('cs!app/common/i18n')
  select = require('select')
  Grid = require('app/common/grid/main')
  Collection = require('cs!app/common/collection')
  Template = require('cs!app/company/models/priceListTemplate')

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-halves'

    modelEvents:
      'change:template': 'renderGrid'

    templateHelpers: ->
      isNew: @model.isNew()

    onRender: ->
      @renderTemplateSelect()

    templateFormatter: (obj) =>
      if obj.text then obj.text else obj.name

    renderTemplateSelect: ->
      select(@ui.$templateSelect, {
        id: (object) ->
          return object._id
        ajax:
          url: '/pricelisttemplate/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @templateFormatter
        formatResult: @templateFormatter
        initSelection: (element, callback) =>
          callback(@model.get('template'))
      })
      @ui.$templateSelect.select2('val', @model.get('template')) if @model.get('template')

    renderGrid: ->
      columns = [
        {
          field: 'nomenclature'
          title: i18n.get('nomenclature')
          placeholder: i18n.get('selectNomenclature')
          type: 'select'
          url: '/nomenclature/select/fetch'
        }
      ]

      templateModel = new Template {
        _id: @model.get('template')
      }, { parse: true }

      templateModel.fetch().then =>
        _.each templateModel.get('columns'), (column) ->
          columns.push {
            field: column.id
            title: i18n.get(column.value.toLowerCase()) + '(' + column.amount + ')'
            type: 'number'
          }

        @itemsWrapper.show new Grid({
          collection: new Collection
          defaultEmptyText: i18n.get('emptyPriceListItemsText')
          editable: @
          columns: columns
        })

    submit: ->
      @model.save().then =>
        @navigateTo('/templates')
