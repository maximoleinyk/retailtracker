define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  Grid = require('util/grid/main')

  Layout.extend

    template: require('hbs!./home')

    createCompany: ->
      @navigate('company/create')

    onRender: ->
      @companies.show new Grid({
        collection: @options.companies
        defaultEmptyText: window.RetailTracker.i18n.emptyCompanyGridMessage
        columns: [
          {
            field: 'name'
            title: window.RetailTracker.i18n.name
            type: 'string'
            width: 250
          }
          {
            field: 'description'
            title: window.RetailTracker.i18n.description
            type: 'string'
          }
          {
            field: 'employeeCount'
            title: window.RetailTracker.i18n.employeeCount
            type: 'number'
            width: 150
          }
        ]
      })