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
      # TODO: use grid only for view and separate page for edit
      @grid.show new Grid({
        collection: @collection
        defaultEmptyText: 'Вы еще не создали ни одного контрагента' # TODO: i18n
        columns: [
          {
            field: 'name'
            title: i18n.get('name')
            type: 'string'
            url: (model) =>
              '/counterparty/' + model.id + '/edit'
          }
          {
            field: 'address'
            title: 'Address' # TODO: i18n
            type: 'string'
          }
          {
            field: 'phone'
            title: 'Phone' # TODO: i18n
            type: 'string'
          }
          {
            field: 'bankIdentifier'
            title: 'Bank Identifier' # TODO: i18n
            type: 'number'
          }
          {
            field: 'bankAccountIdentifier'
            title: 'Bank Account Identifier' # TODO: i18n
            type: 'number'
          }
        ]
      })
