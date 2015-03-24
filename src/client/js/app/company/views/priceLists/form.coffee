define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  i18n = require('cs!app/common/i18n')
  select = require('select')
  Grid = require('app/common/grid/main')
  Formula = require('cs!app/company/models/formula')
  helpers = require('app/common/helpers');

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-halves'

    modelEvents:
      'change:formula': 'renderGrid'

    templateHelpers: ->
      isNew: @model.isNew()

    onRender: ->
      @renderCurrencySelect()
      @renderFormulaSelect()
      @buildGrid(new Formula @model.get('formula'), {parse: true}) if not @model.isNew()

    formulaFormatter: (obj) =>
      if obj.text then obj.text else obj.name

    currencyFormatter: (obj) =>
      if obj.text then obj.text else obj.name

    renderCurrencySelect: ->
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
      @model.set('currency', currencyObject._id, {silent: true}) if @model.get('currency')
      @ui.$currencySelect.select2('enable', false) if not @model.isNew()

    renderFormulaSelect: ->
      formulaObject = @model.get('formula')
      select(@ui.$formulaSelect, {
        id: (object) ->
          return object._id
        ajax:
          url: '/formula/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @formulaFormatter
        formatResult: @formulaFormatter
        initSelection: (element, callback) =>
          callback(@model.get('formula'))
      })
      @ui.$formulaSelect.select2('val', @model.get('formula')) if @model.get('formula')
      @ui.$formulaSelect.select2('enable', false) if not @model.isNew()

    navigate: ->
      @navigateTo('/pricelists/' + @model.id)

    renderGrid: ->
      if @model.isNew()
        @save().then =>
          @navigate()
      else
        @navigate()

    buildGrid: (formulaModel) ->
      columns = [
        {
          field: 'nomenclature'
          title: i18n.get('nomenclature')
          placeholder: i18n.get('selectNomenclature')
          type: 'select'
          limit: 5
          ajaxUrl: '/nomenclature/select/fetch'
          url: (model) ->
            '/nomenclature/' + model.get('nomenclature._id')
          onSelection: (object, model) ->
            attributes = model.toJSON()
            delete attributes.nomenclature
            _.each attributes, (value, key) ->
              model.set(key, 0);
          formatResult: (object) =>
            if object.text then object.text else object.name
          formatter: (object) ->
            object?.name
        }
      ]

      _.each formulaModel.get('columns'), (column) =>
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
          result.title = i18n.get('price')
          result.events =
            blur: (value, model, done) =>
              return done() if not +value or not model.get('nomenclature')
              model.set('formula', formulaModel.get('id'))
              model.set('priceList', @model.id)
              model.generatePrices().then ->
                done()
              .catch(done)
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

      @model.set('formula', formulaModel.get('id'), {silent: true})

    onCreate: (model, callback) ->
      model.unset('formula')
      model.set('priceList', @model.id)
      model.save().then =>
        @options.priceListItems.add(model)
        callback()
      .catch ->
        callback(model.get('errors'))

    onSave: (model, callback) ->
      originNomenclature = model.get('nomenclature')
      model.unset('formula')
      model.set('nomenclature', model.get('nomenclature._id'))
      model.save().then ->
        model.set('nomenclature', originNomenclature)
        callback()
      .catch ->
        callback(model.get('errors'))

    onDelete: (model, callback) ->
      model.destroy().then(callback).catch ->
        callback(model.get('errors'))

    onCancel: (model, callback) ->
      model.reset()
      callback()

    save: ->
      @model.save().then =>
        @navigateTo('/pricelists/' + @model.id)

    delete: ->
      @model.destroy().then =>
        @navigateTo('/pricelists')
