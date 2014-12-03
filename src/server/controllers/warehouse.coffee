HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class WarehouseController

  constructor: (@warehouseService) ->

  register: (@router) ->
    @router.get '/warehouse/select/fetch', authFilter, (req, res) =>
      @warehouseService.search namespace.company(req), req.query.q, (err, results) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.jsonp(results)

    @router.get '/warehouse/all', authFilter, (req, res) =>
      @warehouseService.findAll namespace.company(req), (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.post '/warehouse/create', authFilter, (req, res) =>
      @warehouseService.create namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.delete '/warehouse/delete', authFilter, (req, res) =>
      @warehouseService.delete namespace.company(req), req.body.id, (err) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.NO_CONTENT).end()

    @router.put '/warehouse/update', authFilter, (req, res) =>
      @warehouseService.update namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = WarehouseController
