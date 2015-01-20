AbstractService = inject('services/abstractService')

class WarehouseService extends AbstractService

  search: (ns, query = '', callback) ->
    @findAll ns, (err, all) ->
      results = _.filter all, (item) ->
        item.name.toLowerCase().indexOf(query.toLowerCase()) > -1
      callback(err, results.splice(0, 5))

module.exports = WarehouseService
