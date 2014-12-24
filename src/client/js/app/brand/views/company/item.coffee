define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  context = require('cs!app/common/context')

  ItemView.extend

    template: require('hbs!./item.hbs')
    className: 'company-item'

    templateHelpers: ->
      isOwner: @model.get('owner')._id is context.get('owner').id

    openCompany: (e) ->
      e.preventDefault()
      @eventBus.trigger('module:load', 'company', @model.id)