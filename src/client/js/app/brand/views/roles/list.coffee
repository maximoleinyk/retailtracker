define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  i18n = require('cs!app/common/i18n')
  $ = require('jquery')

  ItemView.extend

    template: require('hbs!./list.hbs')
    className: 'page'

    events:
      'mouseover td': 'addClass'
      'mouseout td': 'removeClass'

    templateHelpers: ->
      roles: @options.roles.map (model) ->
        i18n.get(model.get('name').toLowerCase())
      properties: _.map _.omit(@options.roles.models[0].toJSON(), ['name', 'description', 'id']), (value, key) =>
        permissionItem: i18n.get(key)
        values: @options.roles.map (role) ->
          role.get(key)

    addClass: (e) ->
      $td = $(e.currentTarget)
      return if $td.index() is 0
      $td.closest('table').find('tr td:nth-child(' + ($td.index() + 1) + ')').addClass('hover')

    removeClass: (e) ->
      $(e.currentTarget).closest('table').find('tr td').removeClass('hover')

