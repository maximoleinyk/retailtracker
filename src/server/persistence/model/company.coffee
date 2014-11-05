mongoose = require('mongoose')

class CompanySchema

  constructor: ->
    @schema = mongoose.Schema
      name:
        type: String
        required: true
      description:
        type: String
        default: ''
      owner:
        type: mongoose.Schema.Types.ObjectId
        required: true
      currencyCode:
        type: String
        required: true
      currencyRate:
        type: Number
        required: true
      employees: [
        {
          type: mongoose.Schema.Types.ObjectId
          ref: 'User'
        }
      ]
      invitees: [{
        firstName:
          type: String
          required: true
        email:
          type: String
          required: true
        role: String
      }]
    return @

  get: (namespace) ->
    mongoose.model('Company', @schema, namespace('companies'))

module.exports = CompanySchema