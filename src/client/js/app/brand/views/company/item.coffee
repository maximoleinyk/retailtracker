define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.ItemView.extend

    template: require('hbs!./item')
    className: 'company-item'

    openCompany: (e) ->
      e.preventDefault()
      # TODO: implement

    makeDefault: (e) ->
      e.preventDefault()
      # TODO: implement
