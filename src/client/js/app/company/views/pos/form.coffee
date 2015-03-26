define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  i18n = require('cs!app/common/i18n')
  select = require('select')
  Grid = require('app/common/grid/main')
  Employees = require('app/company/collections/employees')
  ActionCell = require('cs!./actionCell')

  Layout.extend

    template: require('hbs!./form.hbs')
    className: 'page page-halves'

    initialize: ->
      @cashiers = new Employees(@model.get('cashiers'), {parse: true})

    templateHelpers: ->
      isNew: @model.isNew()

    onRender: ->
      @renderStoreSelect()
      @renderGrid()

    storeFormatter: (obj) =>
      if obj.text then obj.text else obj.name

    renderGrid: ->
      @cashiersWrapper.show new Grid
        collection: @cashiers
        defaultEmptyText: i18n.get('cashiersEmptyListLabel')
        skipInitialAutoFocus: true
        editable: this
        editableCell: ActionCell
        columns: [
          {
            field: 'id'
            title: i18n.get('cashier')
            placeholder: i18n.get('selectEmployee')
            type: 'select'
            limit: 5
            ajaxUrl: '/employees/select/fetch'
            formatResult: @cashierFormatter
            formatSelection: @cashierFormatter
            formatter: (id) =>
              if id then @cashiers.get(id)?.get('email') else ''
          }
        ]

    cashierFormatter: (obj) =>
      if obj.text then obj.text else obj.firstName + ' ' + obj.lastName + ' ' + obj.email

    onCreate: (cashier, callback) ->
      return callback({id: i18n.get('cashierShouldBeSelected')}) if not cashier.get('id')
      cashier.fetch().then =>
        cashier.commit()
        @cashiers.add(cashier)
        @model.set('cashiers', @cashiers.pluck('id'))
        @model.validate({sync: true})
        callback()

    onSave: (cashier, callback) ->
      cashier.commit()
      @model.set('cashiers', @cashiers.pluck('id'))
      callback()

    onCancel: (cashier, callback) ->
      cashier.reset()
      callback()

    onDelete: (cashier, callback) ->
      @cashiers.remove(cashier)
      @model.set('cashiers', @cashiers.pluck('id'))
      callback()

    renderStoreSelect: ->
      store = @model.get('store')
      select @ui.$storeSelect,
        id: (object) ->
          return object._id
        ajax:
          url: '/store/select/fetch'
          dataType: 'jsonp'
          quietMillis: 150,
          data: (term) ->
            q: term
          results: (data) ->
            results: data
        formatSelection: @storeFormatter
        formatResult: @storeFormatter
        initSelection: (element, callback) =>
          callback(store)
      @model.set('store', store._id, {silent: true}) if @model.get('store')

    submit: ->
      @model.save().then =>
        @navigateTo('/pos')
