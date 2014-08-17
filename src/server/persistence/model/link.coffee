mongoose = require('mongoose')

schema = mongoose.Schema
  email:
    type: String
    unique: true
    required: true
  link:
    type: String
    unique: true
    required: true

module.exports = mongoose.model('Link', schema)
