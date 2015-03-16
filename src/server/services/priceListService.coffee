_ = require('underscore')
AbstractService = inject('services/abstractService')

class PriceListService extends AbstractService

  search: (ns, query = '', callback) ->
    @findAll ns, (err, all) ->
      results = _.filter all, (item) ->
        item.name.toLowerCase().indexOf(query.toLowerCase()) > -1
      callback(err, results.splice(0, 5))

  delete: (ns, id, callback) ->
    @findById ns, id, (err, document) =>
      data = document.toJSON()
      data.template = data.template._id
      data.state = 'DELETED'
      @update(ns, data, callback)

  activate: (ns, id, callback) ->
    @findById ns, id, (err, document) ->
      return callback(err) if err
      data = document.toJSON()
      data.template = data.template._id
      data.state = 'ACTIVATED'
      @update(ns, data, callback)

module.exports = PriceListService
