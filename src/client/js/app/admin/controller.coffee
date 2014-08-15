define (require) ->
  'use strict'

  BaseController = require('cs!app/common/controller');
  HomePage = require('cs!./view/home')

  BaseController.extend
    home: ->
      @openPage new HomePage
