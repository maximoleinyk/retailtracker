mongoose = require('mongoose')

class RoleSchema

  constructor: ->
    mongoose.mtModel 'Role', mongoose.Schema
      name:
        type: String
        required: true
        unique: true
      description:
        type: String
        default: ''
      accessPos:
        type: Boolean
        default: true
      accessCompany: Boolean
      accessBrand: Boolean
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Role'))

module.exports = RoleSchema
