HttpStatus = require('http-status-codes')
CrudController = inject('controllers/crudController')
namespace = inject('util/namespace')
companyFilter = inject('filters/company')

class CurrencyController extends CrudController

  baseUrl: '/currency'
  filter: companyFilter
  namespace: namespace.company

  register: (router) ->
    super

    router.get @baseUrl + '/templates/get', (req, res) =>
      @service.getCurrencyTemplates(@callback(res))

module.exports = CurrencyController

