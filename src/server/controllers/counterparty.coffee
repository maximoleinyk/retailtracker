HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class CounterpartyController

  constructor: (@counterpartyService) ->

  register: (@router) ->

    @router.get '/counterparty/all', authFilter, (req, res) =>
      @counterpartyService.findAll namespace.company(req), (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.get '/counterparty/:id', authFilter, (req, res) =>
      @counterpartyService.findById namespace.company(req), req.params.id, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.post '/counterparty/create', authFilter, (req, res) =>
      @counterpartyService.create namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.delete '/counterparty/delete', authFilter, (req, res) =>
      @counterpartyService.delete namespace.company(req), req.body.id, (err) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.NO_CONTENT).end()

    @router.put '/counterparty/update', authFilter, (req, res) =>
      @counterpartyService.update namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = CounterpartyController
