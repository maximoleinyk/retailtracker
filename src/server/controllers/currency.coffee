HttpStatus = require('http-status-codes')
CrudController = inject('controllers/crudController')
authFilter = inject('util/authFilter')

class CurrencyController extends CrudController

  baseUrl: '/currency'

  register: (router) ->
    super

    router.get @baseUrl + '/templates/get', authFilter, (req, res) =>
      @service.getCurrencyTemplates(@callback(res))

module.exports = CurrencyController

