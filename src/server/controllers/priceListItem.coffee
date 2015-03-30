CrudController = inject('controllers/crudController')
HttpStatus = require('http-status-codes')
companyFilter = inject('filters/company')
namespace = inject('util/namespace')

class PriceListItemController extends CrudController

  baseUrl: '/pricelistitems'
  namespace: namespace.company
  filter: companyFilter

  register: (router) ->
    super

    router.get @baseUrl + '/list/:priceListId', @filter, (req, res) =>
      @service.findAllByPriceListId(@namespace(req), req.param('priceListId'), @callback(res))

    router.post @baseUrl + '/generate/prices', @filter, (req, res) =>
      @service.generatePrices @namespace(req), req.body, @callback(res)

module.exports = PriceListItemController
