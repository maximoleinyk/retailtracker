CrudController = inject('controllers/crudController')
companyFilter = inject('filters/company')
namespace = inject('util/namespace')

class ReceiveGoodsController extends CrudController

  baseUrl: '/receivegoods'
  namespace: namespace.company
  filter: companyFilter

  register: (router) ->
    router.post @baseUrl + '/updatetotals', @filter, (req, res) =>
      @service.updateTotals @namespace(req), req.body, @callback(res)

    router.post @baseUrl + '/enter/:id', @filter, (req, res) =>
      @service.enter @namespace(req), req.param('id'), @callback(res)

    super

module.exports = ReceiveGoodsController
