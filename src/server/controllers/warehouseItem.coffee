ReadableController = inject('controllers/readableController')
company = inject('filters/company')
namespace = inject('util/namespace')

class WarehouseItemController extends ReadableController

  baseUrl: '/warehouseitem'
  filter: company
  namespace: namespace.company

module.exports = WarehouseItemController
