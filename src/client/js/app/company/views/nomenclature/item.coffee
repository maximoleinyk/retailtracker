define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')

  ItemView.extend

    template: require('hbs!./item.hbs')
    tagName: 'li'

    delete: ->
      @model.delete().then =>
        @model.trigger('destroy', @model, @model.collection);
