HttpStatus = require('http-status-codes')

class CurrencyController

  constructor: (@currencyService) ->

  register: (@router, authFilter) ->
    @router.get '/currency/all', authFilter, (req, res) =>
      @currencyService.findAll (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = CurrencyController
