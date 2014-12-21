define (require) ->
  'use strict'

  Marionette = require('marionette')
  context = require('cs!app/common/context')

  Marionette.ItemView.extend

    template: require('hbs!./item.hbs')
    className: 'company-item'

    templateHelpers: ->
      isOwner: @model.get('owner')._id is context.get('owner').id

    openCompany: (e) ->
      e.preventDefault()
      @eventBus.trigger('module:load', 'company', @model.id)