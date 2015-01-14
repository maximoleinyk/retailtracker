mongoose = require('mongoose')

Schema = mongoose.Schema
  account:
    type: mongoose.Schema.Types.ObjectId
    required: true
  link:
    type: String
    unique: true
    required: true

module.exports = mongoose.model('Link', Schema)
