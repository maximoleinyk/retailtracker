define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  i18n = require('cs!app/common/i18n')
  Handlebars = require('handlebars')

  ItemView.extend

    template: require('hbs!./list.hbs')

    initialize: ->
      Handlebars.registerHelper 'hasPermission', (conditional, options) ->
        options.fn(this)

    templateHelpers: ->
      properties: _.values(_.omit(@options.roles.models[0].toJSON(), ['name', 'description', 'id']))
      roles: @options.roles.toJSON()
