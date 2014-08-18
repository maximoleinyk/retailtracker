define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  HomePage = require('cs!./view/home')

  Controller.extend
    home: ->
      @openPage new HomePage
