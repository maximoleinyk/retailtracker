mongoose = require('mongoose')

schema = mongoose.Schema
  name:
    type: String
    required: true
  description:
    type: String
    default: ''
  owner:
    type: mongoose.Schema.Types.ObjectId
    required: true
  currencyCode:
    type: String
    required: true
  currencyRate:
    type: Number
    required: true
  employees: [mongoose.Schema.Types.ObjectId]
  invitees: [String]

module.exports = mongoose.model('Company', schema)
