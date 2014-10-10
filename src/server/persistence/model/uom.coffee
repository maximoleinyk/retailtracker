mongoose = require('mongoose')

schema = mongoose.Schema
  name:
    type: String
    required: true
  description: String

module.exports = mongoose.model('Uom', schema)
