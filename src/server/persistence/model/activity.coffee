mongoose = require('mongoose')

class ActivitySchema

  constructor: ->
    @schema = mongoose.Schema
      user:
        type: mongoose.Schema.Types.ObjectId
        ref: 'User'
        required: true
      dateTime:
        type: Date
        required: true
        default: Date.now
      action:
        type: String
        required: true
    return @

  get: (namespace) ->
    mongoose.model('Activity', @schema, namespace('activities'))

module.exports = ActivitySchema
