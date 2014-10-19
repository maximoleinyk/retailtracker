HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class CurrencyController

  constructor: (@currencyService) ->

  register: (@router) ->
    @router.get '/currency/all', authFilter, (req, res) =>
      @currencyService.findAll (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = CurrencyController
