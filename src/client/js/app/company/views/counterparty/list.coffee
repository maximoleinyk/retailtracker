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

    initialize: (options) ->
      @collection = options.collection

    onRender: ->
      @grid.show new Grid({
        collection: @collection
        defaultEmptyText: i18n.get('counterpartyEmptyList')
        columns: [
          {
            field: 'name'
            title: i18n.get('name')
            type: 'string'
            url: (model) ->
              '/counterparty/' + model.id + '/edit'
          }
          {
            field: 'code'
            title: i18n.get('code')
            type: 'string'
          }
          {
            field: 'phone'
            title: i18n.get('phone')
            type: 'string'
          }
          {
            field: 'email'
            title: i18n.get('email')
            type: 'string'
          }
          {
            type: 'button'
            buttonIcon: 'fa-remove'
            action: (e, model) =>
              model.delete()
              .then @collection.fetch()
          }
        ]
      })
