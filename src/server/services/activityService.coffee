class ActivityService

  constructor: (@activityStore) ->

  fetch: (ns, callback) ->
    @activityStore.fetch(ns, callback)

module.exports = ActivityService