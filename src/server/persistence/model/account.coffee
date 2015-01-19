mongoose = require('mongoose')
_ = require('underscore')

schema = mongoose.Schema
  owner:
    type: mongoose.Schema.Types.ObjectId
    ref: 'User'
    required: true
  dependsFrom: [
    {
      type: mongoose.Schema.Types.ObjectId
      ref: 'Account'
      'default': []
    }
  ]
  status:
    type: String
    default: 'ACTIVATED' # SUSPENDED ACTIVATED
  type:
    type: String
    default: 'OWN'
  login:
    type: String
    unique: true
    required: true
  password:
    type: String
    required: true
  companies: [
    {
      account:
        type: mongoose.Schema.Types.ObjectId
        required: true
      company:
        type: mongoose.Schema.Types.ObjectId
        required: true
    }
  ]

schema.index({ login: 1 }, { unique: true })

module.exports = mongoose.model('Account', schema)
