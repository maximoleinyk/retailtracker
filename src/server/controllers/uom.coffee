CrudController = inject('controllers/crudController')
company = inject('filters/company')

class UomController extends CrudController

  baseUrl: '/uom'
  filter: company

module.exports = UomController
