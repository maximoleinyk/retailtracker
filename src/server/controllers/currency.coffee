HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class CurrencyController

  constructor: (@currencyService) ->

  register: (@router) ->

    @router.get '/currency/templates', authFilter, (req, res) =>
      @currencyService.getCurrencyTemplates (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.get '/currency/all', authFilter, (req, res) =>
      @currencyService.findAll namespace.company(req), (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.post '/currency', authFilter, (req, res) =>
      @currencyService.create namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.delete '/currency/:id', authFilter, (req, res) =>
      @currencyService.delete namespace.company(req), req.body.id, (err) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.NO_CONTENT).end()

    @router.put '/currency/:id', authFilter, (req, res) =>
      @currencyService.update namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = CurrencyController
