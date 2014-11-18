define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/mongoModel')

  class Activity extends MongoModel