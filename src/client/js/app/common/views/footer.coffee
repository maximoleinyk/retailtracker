define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  moment = require('moment')

  ItemView.extend

    template: require('hbs!./footer.hbs')
    className: 'footer'

    templateHelpers: ->
      year: moment().format('YYYY')
