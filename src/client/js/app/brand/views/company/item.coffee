define (require) ->
  'use strict'

  Marionette = require('marionette')
  userInfo = require('util/userInfo')

  Marionette.ItemView.extend

    template: require('hbs!./item')
    className: 'company-item'

    templateHelpers: ->
      {
        isEditable: @model.get('owner') is userInfo.id
      }

    openCompany: (e) ->
      e.preventDefault()
      # TODO: implement

    makeDefault: (e) ->
      e.preventDefault()
      # TODO: implement
