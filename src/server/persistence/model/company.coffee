mongoose = require('mongoose')

schema = mongoose.Schema
  name:
    type: String
    required: true
  owner:
    type: mongoose.Schema.Types.ObjectId
    required: true
  employeeCount: Number
  invited: [String]

module.exports = mongoose.model('Company', schema)
