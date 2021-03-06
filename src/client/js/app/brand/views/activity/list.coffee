define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  moment = require('moment')

  ItemView.extend

    template: require('hbs!./list.hbs')
    className: 'activity-list'

    templateHelpers: ->
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