define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.ItemView.extend

    template: require('hbs!./item')
    tagName: 'li'

    delete: ->
      @model.delete().then =>
        @model.trigger('destroy', @model, @model.collection);
