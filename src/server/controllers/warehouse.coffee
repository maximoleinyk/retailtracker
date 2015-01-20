CrudController = inject('controllers/crudController')
authFilter = inject('util/authFilter')

class WarehouseController extends CrudController

  baseUrl: '/warehouse'

  register: (@router) ->
    super

    @router.get '/warehouse/select/fetch', authFilter, (req, res) =>
      @warehouseService.search namespace.company(req), req.query.q, (err, results) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.jsonp(results)

module.exports = WarehouseController
