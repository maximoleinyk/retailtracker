define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  i18n = require('cs!app/common/i18n')
  select = require('select')
  Grid = require('app/common/grid/main')
  PriceListItems = require('cs!app/company/collections/priceListItems')
  Template = require('cs!app/company/models/priceListTemplate')
  helpers = require('app/common/helpers');

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
      @submit().then =>
        @navigateTo('/pricelists/' + @model.id)

    buildGrid: (templateModel) ->
      columns = [
        {
          field: 'nomenclature'
          title: i18n.get('nomenclature')
          placeholder: i18n.get('selectNomenclature')
          type: 'select'
          limit: 5
          url: '/nomenclature/select/fetch'
          onSelection: (object, model) ->
            attributes = model.toJSON()
            delete attributes.nomenclature
            _.each attributes, (value, key) ->
              model.set(key, 0);
          formatResult: (object) =>
            if object.text then object.text else object.name
        }
      ]

      _.each templateModel.get('columns'), (column) =>
        result =
          field: column._id
          type: 'number'
          width: 150
          default: 0
          formatter: (value) ->
            helpers.amount(value);

        if column.type is 'PERCENT'
          result.title = column.name + ' ' + column.amount + '%'
        else if column.type is 'COSTPRICE'
          result.title = i18n.get('price') + ' (' + templateModel.get('currency.code') + ')'
          result.events =
            blur: (value, model, done) =>
              return if +value is model.get(column._id) or not +value
              model.generatePrices(@model.id).then(done)
        else
          result.title = column.name + ' ' + column.amount

        columns.push(result)

      @gridWraper.show new Grid({
        collection: @options.priceListItems
        skipInitialAutoFocus: true
        defaultEmptyText: i18n.get('emptyPriceListItemsText')
        editable: @
        columns: columns
      })

    onCreate: (model, callback) ->
      # validate columns
      model.save().then ->
        callback()

    submit: ->
      @model.save().then =>
        @navigateTo('/pricelists')
