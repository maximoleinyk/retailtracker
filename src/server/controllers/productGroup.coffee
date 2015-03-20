CrudController = inject('controllers/crudController')

class ProductGroup extends CrudController
  baseUrl: '/productgroup'

module.exports = ProductGroup
