mongoose = require('mongoose')

Schema = mongoose.Schema

schema = Schema
  userId: Schema.Types.ObjectId
  dateTime: Date
  action: String

module.exports = mongoose.model('Action', schema)
