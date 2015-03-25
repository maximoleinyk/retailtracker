HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')
CrudController = inject('controllers/crudController')

class EmployeeController extends CrudController

  baseUrl: '/employees'

  register: (router) ->
    super

    router.get @baseUrl + '/all/:accountId/:companyId', authFilter, (req, res) =>
      @service.findAll namespace.companyWrapper(req.param('accountId'), req.param('companyId')), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.get @baseUrl + '/autocomplete/fetch', authFilter, (req, res) =>
      match = req.query.match or ''
      limit = req.query.limit or 5
      @service.findLikeByEmail namespace.company(req), match, limit, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

module.exports = EmployeeController
