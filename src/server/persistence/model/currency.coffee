mongoose = require('mongoose')

schema = mongoose.Schema
  name:
    type: String
    required: true
  code:
    type: String
    required: true
  rate:
    type: Number
    required: true

module.exports = mongoose.model('Currency', schema)
