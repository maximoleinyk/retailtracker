CrudController = inject('controllers/crudController')
companyFilter = inject('filters/company')
namespace = inject('util/namespace')

class ProductGroup extends CrudController

  baseUrl: '/productgroup'
  namespace: namespace.company
  filter: companyFilter

module.exports = ProductGroup
