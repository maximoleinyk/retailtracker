mongoose = require('mongoose')

AbstractSchema = inject('util/abstractSchema')

class AccountSchema extends AbstractSchema

  getSchema: ->
    mongoose.Schema
      owner:
        type: mongoose.Schema.Types.ObjectId
        ref: 'User'
        required: true
      dependsFrom:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Account'
        default: null
      login:
        type: String
        required: true
      password:
        type: String
        required: true
      companies: [
        {
          ns:
            type: String
            required: true
          company:
            type: mongoose.Schema.Types.ObjectId
            ref: 'Company'
        }
      ]

  getName: ->
    'Account'

  getCollectionName: ->
    'accounts'

module.exports = AccountSchema