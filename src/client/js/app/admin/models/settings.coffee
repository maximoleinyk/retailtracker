define (require) ->
  'use strict'

  Backbone = require('backbone')
  http = require('util/http')
  Promise = require('rsvp').Promise

  Backbone.Model.extend({})