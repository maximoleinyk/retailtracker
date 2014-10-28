mongoose = require('mongoose')

Schema = mongoose.Schema
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
  companyId:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Company'

Schema.index({ email: 1, link: 1 }, { unique: true })

module.exports = mongoose.model('Invite', Schema)
