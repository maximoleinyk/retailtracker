CrudController = inject('controllers/crudController')
companyFilter = inject('filters/company')
namespace = inject('util/namespace')

class StoreController extends CrudController

  baseUrl: '/store'
  filter: companyFilter
  namespace: namespace.company

module.exports = StoreController
