define (require) ->
  Marionette = require('marionette');
  template = require('hbs!./notFound')

  Marionette.ItemView.extend
    template: template
