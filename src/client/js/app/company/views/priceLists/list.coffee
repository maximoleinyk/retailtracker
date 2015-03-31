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
        defaultEmptyText: i18n.get('thereAreNoPriceLists')
        columns: [
          {
            field: 'name'
            title: i18n.get('name')
            url: (model) ->
              '/pricelists/' + model.id
            width: 350
          },
          {
            field: 'created'
            title: i18n.get('creationDate')
            formatter: (value) ->
              helpers.date(value, true)
            width: 180
          },
          {
            field: 'formula'
            title: i18n.get('formula')
            formatter: (value) ->
              value.name
            url: (model) ->
              '/formula/' + model.get('formula._id')
          },
          {
            field: 'description'
            title: i18n.get('description')
          }
        ]
      })
