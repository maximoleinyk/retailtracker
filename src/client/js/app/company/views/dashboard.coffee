define (require) ->
  'use strict'

  Marionette = require('marionette')
  d3 = require('d3')
  _ = require('underscore')

  Marionette.ItemView.extend

    template: require('hbs!./dashboard.hbs')
    className: 'page page-halves'

    onRender: ->
      Marionette.$.getJSON '/generate/data', (data) =>
        # do nothing