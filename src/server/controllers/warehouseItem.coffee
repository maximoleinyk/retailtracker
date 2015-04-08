ReadableController = inject('controllers/readableController')
company = inject('filters/company')
namespace = inject('util/namespace')

class WarehouseItemController extends ReadableController

  baseUrl: '/warehouseitem'
  filter: company
  namespace: namespace.company

  register: (router) ->
    super

    router.post @baseUrl + '/commodity', @filter, (req, res) =>
      @service.getCommodity @namespace(req), req.body, @callback(res)

    router.post @baseUrl + '/commodity/all', @filter, (req, res) =>
      @service.getItemsCommodity @namespace(req), req.body, @callback(res)

module.exports = WarehouseItemController
