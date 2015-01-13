mongoose = require('mongoose')

class EmployeeSchema

  constructor: ->
    mongoose.mtModel 'Employee', mongoose.Schema
      firstName:
        type: String
        required: true
      lastName: String
      email: String
      phoneNumber: String
      address: String
      role:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Role'
        required: true
        $tenant: true
      companies: [
        {
          type: mongoose.Schema.Types.ObjectId
          ref: 'Company'
        }
      ]
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Employee'))

module.exports = EmployeeSchema
