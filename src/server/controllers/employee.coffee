HttpStatus = require('http-status-codes')
CrudController = inject('controllers/crudController')
namespace = inject('util/namespace')
companyFilter = inject('filters/company')

class EmployeeController extends CrudController

  baseUrl: '/employees'
  namespace: namespace.company

  register: (router) ->
    super

    router.get @baseUrl + '/all/:accountId/:companyId', @filter, (req, res) =>
      @service.findAll namespace.companyWrapper(req.param('accountId'), req.param('companyId')), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.get @baseUrl + '/autocomplete/fetch', @filter, (req, res) =>
      match = req.query.match or ''
      limit = req.query.limit or 5
      @service.findLikeByEmail namespace.company(req), match, limit, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

module.exports = EmployeeController
