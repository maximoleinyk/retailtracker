_ = require('underscore')
AbstractService = inject('services/abstractService')

class PriceListService extends AbstractService

  update: (ns, data) ->
    data.currency = data.currency._id if _.isObject(data.currency)
    data.formula = data.formula._id if _.isObject(data.formula)
    super

  delete: (ns, id, callback) ->
    @findById ns, id, (err, document) =>
      data = document.toJSON()
      data.formula = data.formula._id
      data.currency = data.currency._id
      data.status = 'DELETED'
      @update(ns, data, callback)

module.exports = PriceListService
