define (require) ->
  'use strict'

  Marionette = require('marionette')

  Marionette.Controller.extend
    constructor: ->
      Marionette.Controller::constructor.call(@, arguments)