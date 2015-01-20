define (require) ->
  'use strict'

  Controller = require('cs!app/common/controller');
  HomePage = require('cs!./views/home')

  Controller.extend

    home: ->
      @openPage new HomePage
        collection: new Backbone.Collection()
