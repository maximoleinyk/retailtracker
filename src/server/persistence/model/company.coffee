mongoose = require('mongoose')
moment = require('moment')

class CompanySchema

  constructor: ->
    mongoose.mtModel 'Company', mongoose.Schema
      name:
        type: String
        required: true
      description:
        type: String
        default: ''
      created:
        type: Date
        default: moment().toISOString()
      owner:
        type: mongoose.Schema.Types.ObjectId
        ref: 'User'
        required: true
      currencyCode:
        type: String
        required: true
      currencyRate:
        type: Number
        required: true
      defaultCurrency: mongoose.Schema.Types.ObjectId
      employees: [
        {
          type: mongoose.Schema.Types.ObjectId
          ref: 'Employee'
          $tenant: true
        }
      ]
      invitees: [
        {
          firstName:
            type: String
          email:
            type: String
            required: true
          role:
            type: mongoose.Schema.Types.ObjectId
            required: true
        }
      ]
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Company'))

module.exports = CompanySchema
