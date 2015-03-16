HttpStatus = require('http-status-codes')
CrudController = inject('controllers/crudController')
authFilter = inject('util/authFilter')

class PriceListTemplateController extends CrudController

  baseUrl: '/pricelisttemplate'

  register: (router) ->
    super

    router.post @baseUrl + '/generate/prices', authFilter, (req, res) =>
      @service.generatePrices @namespace(req), req.body, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.put @baseUrl + '/:id/activate', authFilter, (req, res) =>
      @service.activate @namespace(req), req.param('id'), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).jsonp(result)

module.exports = PriceListTemplateController
