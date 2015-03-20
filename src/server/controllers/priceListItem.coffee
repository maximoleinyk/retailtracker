CrudController = inject('controllers/crudController')
HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class PriceListItemController extends CrudController

  baseUrl: '/pricelistitems'

  register: (router) ->
    super

    router.get @baseUrl + '/list/:priceListId', authFilter, (req, res) =>
      @service.findAllByPriceListId(@namespace(req), req.param('priceListId'), @callback(res))

    router.post @baseUrl + '/generate/prices', authFilter, (req, res) =>
      @service.generatePrices @namespace(req), req.body, @callback(res)

module.exports = PriceListItemController
