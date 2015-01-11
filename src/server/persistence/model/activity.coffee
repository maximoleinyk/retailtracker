mongoose = require('mongoose')

class ActivitySchema

  constructor: ->
    mongoose.mtModel 'Activity', mongoose.Schema
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
      company:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Company'
      ns: String
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Activity'))

module.exports = ActivitySchema
