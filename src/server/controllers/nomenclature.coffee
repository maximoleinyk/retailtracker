CrudController = inject('controllers/crudController')
companyFilter = inject('filters/company')
namespace = inject('util/namespace')

class NomenclatureController extends CrudController

  baseUrl: '/nomenclature'
  filter: companyFilter
  namespace: namespace.company

module.exports = NomenclatureController
