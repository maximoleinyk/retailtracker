mongoose = require('mongoose')

schema = mongoose.Schema
  firstName:
    type: String
    required: true
  lastName:
    type: String
    default: ''
  email:
    type: String
    unique: true
    required: true
  password:
    type: String
    required: true

module.exports = mongoose.model('User', schema)
