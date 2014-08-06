define ['marionette', 'hbs!app/common/view/layout/top'], (Marionette, html) ->
  'use strict'

  Marionette.Layout.extend

    el: '#app'
    template: html

    regions:
      container: '#container'

    appEvents:
      'open:page': 'showPage'

    showPage: (view) ->
      @container.show view
