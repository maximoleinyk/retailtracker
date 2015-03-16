AbstractService = inject('services/abstractService')

class PriceListTemplateService extends AbstractService

  delete: (ns, id, callback) ->
    @findById ns, id, (err, document) =>
      data = document.toJSON()
      data.currency = data.currency._id
      data.state = 'DELETED'
      @update(ns, data, callback)

  activate: (ns, id, callback) ->
    @findById ns, id, (err, document) ->
      return callback(err) if err
      data = document.toJSON()
      data.currency = data.currency._id
      data.state = 'ACTIVATED'
      @update(ns, data, callback)

module.exports = PriceListTemplateService
