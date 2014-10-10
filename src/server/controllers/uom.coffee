HttpStatus = require('http-status-codes')

class UomController

  constructor: (@uomService) ->

  register: (@router, authFilter) ->
    @router.get '/uom/all', authFilter, (req, res) =>
      @uomService.findAll (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.post '/uom/create', authFilter, (req, res) =>
      @uomService.create req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = UomController
