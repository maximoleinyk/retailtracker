Model = inject('persistence/model/activity')
moment = require('moment')

class ActivityStore

  constructor: ->
    @model = new Model

  create: (ns, data, callback) ->
    Activity = @model.get(ns)
    activity = new Activity(data)
    activity.save(callback)

  fetch: (ns, callback) ->
    @model.get(ns).find().populate('user').sort({dateTime: -1}).limit(10).exec(callback)

module.exports = ActivityStore