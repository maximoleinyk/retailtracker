mongoose = require('mongoose')
moment = require('moment')

class Formula

  constructor: ->
    mongoose.mtModel 'Formula', mongoose.Schema
      name:
        type: String
        required: true
      description: String
      state:
        type: String
        default: 'DRAFT'
        required: true
      created:
        type: Date
        default: moment()
      columns:
        type: [
          {
            # _id: String
            name: String
            type:
              type: String
            amount: Number
          }
        ]
        required: true
    this

  get: (namespace) ->
    mongoose.mtModel(namespace('Formula'))

module.exports = Formula
