HttpStatus = require('http-status-codes')
CrudController = inject('controllers/crudController')
authFilter = inject('util/authFilter')

class WarehouseController extends CrudController

  baseUrl: '/warehouse'

  register: (router) ->
    super

    router.get @baseUrl + '/select/fetch', authFilter, (req, res) =>
      @service.search @namespace(req), req.query.q, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).jsonp(result)

module.exports = WarehouseController
