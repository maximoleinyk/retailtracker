define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/model')

  class Employee extends MongoModel