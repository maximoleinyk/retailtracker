mongoose = require('mongoose')

schema = mongoose.Schema
  firstName:
    type: String
    required: true
  email:
    type: String
    unique: true
    required: true
  link:
    type: String
    unique: true
    required: true

module.exports = mongoose.model('Invite', schema)
