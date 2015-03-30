HttpStatus = require('http-status-codes')
CrudController = inject('controllers/crudController')
companyFilter = inject('filters/company')
namespace = inject('util/namespace')

class FormulaController extends CrudController

  baseUrl: '/formula'
  filter: companyFilter
  namespace: namespace.company

  register: (router) ->
    super

    router.post @baseUrl + '/generate/prices', @filter, (req, res) =>
      @service.generatePrices @namespace(req), req.body, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.put @baseUrl + '/:id/activate', @filter, (req, res) =>
      @service.activate @namespace(req), req.param('id'), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).jsonp(result)

module.exports = FormulaController
