define (require) ->
  'use strict'

  _ = require('underscore')
  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  context = require('cs!app/common/context')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./list.hbs')
    className: 'page'

    onRender: ->
      @grid.show new Grid({
        collection: @options.collection
        defaultEmptyText: i18n.get('companyGridEmptyLabel')
        columns: [
          {
            field: 'name'
            title: i18n.get('name')
            url: (model) ->
              '/company/' + model.id + '/edit'
          }
          {
            field: 'owner'
            title: i18n.get('owner')
            type: 'string'
            escape: false
            formatter: (object) ->
              "#{object.firstName} #{object.lastName} <span style='color:#888'>#{object.email}</span>"
          }
          {
            field: 'currencyCode'
            title: i18n.get('currency')
            width: 120
          }
          {
            field: 'employees'
            title: i18n.get('countOfEmployees')
            type: 'number'
            width: 165
            formatter: (employees) ->
              employees.length
          }
        ]
      })
