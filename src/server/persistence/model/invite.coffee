mongoose = require('mongoose')

Schema = mongoose.Schema
  user:
    type: mongoose.Schema.Types.ObjectId
    ref: 'User'
    required: true
  link:
    type: String
    unique: true
    required: true
  company:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Company'
    default: null

Schema.index({ email: 1, link: 1 }, { unique: true })

module.exports = mongoose.model('Invite', Schema)
