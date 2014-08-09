define (require) ->
  'use strict'

  BaseController = require('cs!app/common/baseController');
  HomePage = require('cs!app/management/view/home')

  BaseController.extend
    home: ->
      @openPage new HomePage
