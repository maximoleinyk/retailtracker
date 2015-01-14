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
  role:
    type: mongoose.Schema.Types.ObjectId
    default: null
  account: # account of the company
    type: mongoose.Schema.Types.ObjectId
    default: null
  company:
    type: mongoose.Schema.Types.ObjectId
    default: null

module.exports = mongoose.model('Invite', schema)
