HttpStatus = require('http-status-codes')
CrudController = inject('controllers/crudController')
companyFilter = inject('filters/company')
namespace = inject('util/namespace')

class PriceListController extends CrudController

  baseUrl: '/pricelists'
  filter: companyFilter
  namespace: namespace.company

  register: (router) ->
    super

    router.put @baseUrl + '/:id/activate', @filter, (req, res) =>
      @service.activate @namespace(req), req.param('id'), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).jsonp(result)

module.exports = PriceListController
