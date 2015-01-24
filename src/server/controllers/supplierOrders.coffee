CrudController = inject('controllers/crudController')
authFilter = inject('util/authFilter')

class SupplierOrdersController

  baseUrl: '/supplierorders'

  register: (router) ->
    router.get @baseUrl + '/all', authFilter, (req, res) =>
      res.status(200).send([])

module.exports = SupplierOrdersController
