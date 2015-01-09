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
            formatter: (value) ->
              value.firstName + ' ' + value.lastName
          }
          {
            field: 'currencyCode'
            title: i18n.get('currencyCode')
          }
          {
            field: 'employees'
            title: i18n.get('countOfEmployees')
            url: (model) ->
              '/company/' + model.id + '/employees'
            formatter: (employees) ->
              employees.length
          }
        ]
      })
