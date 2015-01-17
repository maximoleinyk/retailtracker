mongoose = require('mongoose')

class EmployeeSchema

  constructor: ->
    mongoose.mtModel 'Employee', mongoose.Schema
      firstName:
        type: String
        required: true
      lastName: String
      email:
        type: String
        unique: true
        required: true
      phoneNumber: String
      address: String
      role:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Role'
        required: true
        $tenant: true
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Employee'))

module.exports = EmployeeSchema
