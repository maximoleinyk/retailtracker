define (require) ->
  'use strict'

  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  i18n = require('cs!app/common/i18n')
  helpers = require('app/common/helpers')

  Layout.extend

    template: require('hbs!./list.hbs')
    className: 'page'

    onRender: ->
      @grid.show new Grid({
        collection: @collection
        defaultEmptyText: i18n.get('thereAreNoTemplates')
        columns: [
          {
            field: 'name'
            title: i18n.get('name')
            url: (model) ->
              '/formula/' + model.id
            width: 350
          },
          {
            field: 'created'
            title: i18n.get('creationDate')
            formatter: (value) ->
              helpers.date(value, true)
            width: 200
          },
          {
            field: 'columns'
            title: i18n.get('priceAmount')
            formatter: (value) ->
              value.length
            type: 'number'
            width: 150
          },
          {
            field: 'description'
            title: i18n.get('description')
          }
        ]
      })
