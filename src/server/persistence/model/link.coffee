mongoose = require('mongoose')

Schema = mongoose.Schema
  email:
    type: String
    unique: true
    required: true
  link:
    type: String
    unique: true
    required: true

Schema.index({ email: 1, link: 1 }, { unique: true })

module.exports = mongoose.model('Link', Schema)
