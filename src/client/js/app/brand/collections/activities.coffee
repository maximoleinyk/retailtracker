define (require) ->
  'use strict'

  MongoCollection = require('cs!app/common/mongoCollection')
  Activity = require('cs!app/brand/models/activity')
  moment = require('moment')

  class Activities extends MongoCollection

    model: Activity

    comparator: (model) ->
      -moment(model.get('dateTime')).valueOf()

    fetch: ->
      @promise('get', '/activity/fetch').then (result) =>
        @reset(result, {parse: true})