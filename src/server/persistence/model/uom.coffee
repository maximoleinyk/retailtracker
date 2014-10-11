mongoose = require('mongoose')

schema = mongoose.Schema
  shortName:
    type: String
    required: true
  fullName: String

module.exports = mongoose.model('Uom', schema)
