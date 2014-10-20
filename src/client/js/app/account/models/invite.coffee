define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/mongoModel')

  class Invitee extends MongoModel