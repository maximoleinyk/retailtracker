define (require) ->
  'use strict'

  Model = require('cs!app/common/model')

  class Employee extends Model

    urlRoot: '/employees'
