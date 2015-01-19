define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  context = require('cs!app/common/context')

  ItemView.extend

    template: require('hbs!./item.hbs')
    tagName: 'li'
    className: 'ellipsis'

    templateHelpers: ->
      isOwn: @model.get('owner._id') is context.get('account.owner._id')

    openCompany: (e) ->
      e.preventDefault()
      @eventBus.trigger('module:load', 'company', @model.id)
