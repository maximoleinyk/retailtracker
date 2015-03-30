CrudController = inject('controllers/crudController')
company = inject('filters/company')
namespace = inject('util/namespace')

class WarehouseController extends CrudController

  baseUrl: '/warehouse'
  filter: company
  namespace: namespace.company

module.exports = WarehouseController
