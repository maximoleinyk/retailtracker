HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class UomController

  constructor: (@uomService) ->

  register: (@router) ->
    @router.get '/uom/select/fetch', authFilter, (req, res) =>
      @uomService.search namespace.company(req), req.query.q, (err, results) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.jsonp(results)

    @router.get '/uom/all', authFilter, (req, res) =>
      @uomService.findAll namespace.company(req), (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.post '/uom/create', authFilter, (req, res) =>
      @uomService.create namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.delete '/uom/delete', authFilter, (req, res) =>
      @uomService.delete namespace.company(req), req.body.id, (err) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.NO_CONTENT).end()

    @router.put '/uom/update', authFilter, (req, res) =>
      @uomService.update namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = UomController
