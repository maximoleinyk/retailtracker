mongoose = require('mongoose')
_ = require('underscore')

schema = mongoose.Schema
  owner:
    type: mongoose.Schema.Types.ObjectId
    ref: 'User'
    required: true
  dependsFrom:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Account'
    default: null
  status:
    type: String
    required: true
    default: 'OWN'
  login:
    type: String
    required: true
  password:
    type: String
    required: true
  companies: [
    {
      ns:
        type: String
        required: true
      company:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Company'
    }
  ]

module.exports = mongoose.model('Account', schema)