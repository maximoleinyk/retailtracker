define (require) ->
  'use strict'

  Marionette = require('marionette')
  context = require('cs!app/common/context')

  Marionette.ItemView.extend

    template: require('hbs!./item')
    className: 'company-item'

    templateHelpers: ->
      {
        isOwner: @model.get('owner')._id is context.id
      }

    makeDefault: (e) ->
      e.preventDefault()
      # TODO: implement
