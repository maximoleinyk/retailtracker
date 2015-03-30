CrudController = inject('controllers/crudController')
company = inject('filters/company')
namespace = inject('util/namespace')

class SupplierOrdersController extends CrudController

  baseUrl: '/supplierorders'
  filter: company
  namespace: namespace.company

module.exports = SupplierOrdersController
