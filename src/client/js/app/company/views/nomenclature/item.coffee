define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.ItemView.extend

    template: require('hbs!./item.hbs')
    tagName: 'li'

    delete: ->
      @model.delete().then =>
        @model.trigger('destroy', @model, @model.collection);
