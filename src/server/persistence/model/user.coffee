mongoose = require('mongoose')

schema = mongoose.Schema
  firstName: String
    required: true
  lastName: String
  email:
    type: String
    unique: true
    required: true
  password:
    type: String
    required: true

module.exports = mongoose.model('User', schema)
