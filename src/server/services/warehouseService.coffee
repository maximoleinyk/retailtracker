i18n = inject('util/i18n').bundle('validation')
AbstractService = inject('services/abstractService')

class WarehouseService extends AbstractService

  search: (ns, query, callback) ->
    query = query or ''
    @findAll ns, (err, all) ->
      results = _.filter all, (item) ->
        item.name.toLowerCase().indexOf(query.toLowerCase()) > -1
      results = results.splice(0, 5)
      callback(err, results)

module.exports = WarehouseService
