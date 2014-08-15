mongoose = require('mongoose')

schema = mongoose.Schema
  firstName: String
  lastName: String
  email: String
  password: String

module.exports = mongoose.model('User', schema)
