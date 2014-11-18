define (require) ->
  'use strict'

  Layout = require('cs!app/common/layout')
  moment = require('moment')

  Layout.extend

    template: require('hbs!./list')

    templateHelpers: ->
      {
      groups: =>
        result = {}
        @options.collection.each (model) =>
          date = moment(model.get('dateTime')).hours(0).minutes(0).seconds(0).milliseconds(0)
          activities = result[date.toISOString()]
          if not activities
            activities = []
            result[date.toISOString()] = activities
          activities.push(model.toJSON())
        result
      }