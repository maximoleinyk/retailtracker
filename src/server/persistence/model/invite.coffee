mongoose = require('mongoose')

schema = mongoose.Schema
  firstName:
    type: String
  email:
    type: String
    unique: true
    required: true
  link:
    type: String
    unique: true
    required: true
  companyId: mongoose.Schema.Types.ObjectId

module.exports = mongoose.model('Invite', schema)
