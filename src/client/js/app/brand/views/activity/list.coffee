define (require) ->
  'use strict'

  Marionette = require('marionette')
  moment = require('moment')

  Marionette.ItemView.extend

    template: require('hbs!./list')
    className: 'activity-list'

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