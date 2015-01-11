mongoose = require('mongoose')

class CompanySchema

  constructor: ->
    mongoose.mtModel 'Company', mongoose.Schema
      name:
        type: String
        required: true
      description:
        type: String
        default: ''
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
          ref: 'User'
        }
      ]
      invitees: [
        {
          firstName:
            type: String
            required: true
          email:
            type: String
            required: true
          role: String
        }
      ]
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Company'))

module.exports = CompanySchema
