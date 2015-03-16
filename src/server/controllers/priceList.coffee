HttpStatus = require('http-status-codes')
CrudController = inject('controllers/crudController')
authFilter = inject('util/authFilter')

class PriceListController extends CrudController

  baseUrl: '/pricelists'

  register: (router) ->
    super

    router.get @baseUrl + '/select/fetch', authFilter, (req, res) =>
      @service.search @namespace(req), req.query.q, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).jsonp(result)

    router.put @baseUrl + '/:id/activate', authFilter, (req, res) =>
      @service.activate @namespace(req), req.param('id'), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).jsonp(result)

module.exports = PriceListController
