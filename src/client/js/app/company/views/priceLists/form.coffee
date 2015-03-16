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
      @buildGrid(new Template @model.get('template'), {parse: true}) if not @model.isNew()

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
      templateModel = new Template {
        _id: @model.get('template')
      }, { parse: true }
      templateModel.fetch().then =>
        @buildGrid(templateModel)

    buildGrid: (templateModel) ->
      columns = [
        {
          field: 'nomenclature'
          title: i18n.get('nomenclature')
          placeholder: i18n.get('selectNomenclature')
          type: 'select'
          url: '/nomenclature/select/fetch'
        }
      ]
      _.each templateModel.get('columns'), (column) ->
        switch column.type
          when 'PERCENT' then title = column.amount + '%'
          when 'COSTPRICE' then title = i18n.get('costPrice')
          else
            title = column.amount
        columns.push {
          field: column._id
          title: title
          type: 'number'
          width: 150
          default: 0
        }
      @gridWraper.show new Grid({
        collection: new Collection
        defaultEmptyText: i18n.get('emptyPriceListItemsText')
        editable: @
        columns: columns
      })

    submit: ->
      @model.save().then =>
        @navigateTo('/pricelists')
