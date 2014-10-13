Currency = inject('persistence/model/currency')
_ = require('underscore')

class CurrencyStore

  findAll: (callback) ->
    Currency.find({}, callback)

module.exports = CurrencyStore