Model = inject('persistence/model/currency')
_ = require('underscore')

class CurrencyStore

  constructor: ->
    @model = new Model

  create: (ns, data, callback) ->
    Currency = @model.get(ns)

    currency = new Currency(data)
    currency.save(callback)

  delete: (ns, id, callback) ->
    @model.get(ns).findByIdAndRemove(id, callback)

  update: (ns, data, callback) ->
    @model.get(ns).update({_id: data.id or data._id}, _.omit(data, ['_id']), callback)

  findAll: (ns, callback) ->
    @model.get(ns).find({}, callback)

module.exports = CurrencyStore