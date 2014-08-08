define (require) ->
  'use strict'

  Marionette = require('marionette')
  template = require('hbs!./layout')

  Marionette.Layout.extend

    el: '#app'
    template: template

    regions:
      container: '#container'

    appEvents:
      'open:page': 'openPage'

    openPage: (view) ->
      @container.show view
