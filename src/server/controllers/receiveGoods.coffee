CrudController = inject('controllers/crudController')
companyFilter = inject('filters/company')
namespace = inject('util/namespace')

class ReceiveGoodsController extends CrudController

  baseUrl: '/receivegoods'
  namespace: namespace.company
  filter: companyFilter

module.exports = ReceiveGoodsController
