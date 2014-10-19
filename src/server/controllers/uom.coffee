HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class UomController

  constructor: (@uomService) ->

  register: (@router) ->
    @router.get '/uom/all', authFilter, (req, res) =>
      @uomService.findAll (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.post '/uom/create', authFilter, (req, res) =>
      @uomService.create req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.delete '/uom/delete', authFilter, (req, res) =>
      @uomService.delete req.body.id, (err) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.NO_CONTENT).end()

    @router.put '/uom/update', authFilter, (req, res) =>
      @uomService.update req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = UomController
