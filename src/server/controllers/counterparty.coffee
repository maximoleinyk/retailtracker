CrudController = inject('controllers/crudController')
namespace = inject('util/namespace')
companyFilter = inject('filters/company')

class CounterpartyController extends CrudController

  baseUrl: '/counterparty'
  filter: companyFilter
  namespace: namespace.company

module.exports = CounterpartyController
