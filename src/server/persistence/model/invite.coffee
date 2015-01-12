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
    default: null
  role:
    type: mongoose.Schema.Types.ObjectId
    # required: true
  ns:
    type: String
    default: ''

Schema.index({ email: 1, link: 1 }, { unique: true })

module.exports = mongoose.model('Invite', Schema)
