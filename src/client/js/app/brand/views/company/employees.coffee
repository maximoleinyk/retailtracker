define (require) ->
  'use strict'

  _ = require('underscore')
  Layout = require('cs!app/common/marionette/layout')
  Grid = require('app/common/grid/main')
  context = require('cs!app/common/context')
  i18n = require('cs!app/common/i18n')

  Layout.extend

    template: require('hbs!./employees.hbs')
    className: 'page'

    onRender: ->
      @grid.show new Grid({
        collection: @options.collection
        columns: [
          {
            field: 'firstName'
            title: i18n.get('firstName')
          }
          {
            field: 'lastName'
            title: i18n.get('lastName')
          }
          {
            field: 'email'
            title: i18n.get('email')
          }
          {
            field: 'role'
            title: i18n.get('role')
          }
        ]
      })
