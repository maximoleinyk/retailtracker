define (require) ->
  'use strict'

  Marionette = require('marionette')
  moment = require('moment')

  Marionette.ItemView.extend

    template: require('hbs!./footer.hbs')
    className: 'footer'

    templateHelpers: ->
      year: moment().format('YYYY')
