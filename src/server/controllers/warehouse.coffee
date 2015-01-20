CrudController = inject('controllers/crudController')
authFilter = inject('util/authFilter')

class WarehouseController extends CrudController

  baseUrl: '/warehouse'

  register: (router) ->
    super

    router.get @baseUrl + '/select/fetch', authFilter, (req, res) =>
      @service.search(@namespace(req), req.query.q, @callback(res))

module.exports = WarehouseController
