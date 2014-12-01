HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class NomenclatureController

  constructor: (@nomenclatureService) ->

  register: (router) ->
    router.get '/nomenclature/all', authFilter, (req, res) =>
      @nomenclatureService.findAll namespace.company(req), (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.get '/nomenclature/:id', authFilter, (req, res) =>
      @nomenclatureService.findById namespace.company(req), req.params.id, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.post '/nomenclature/create', authFilter, (req, res) =>
      @nomenclatureService.create namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.put '/nomenclature/update', authFilter, (req, res) =>
      @nomenclatureService.update namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.delete '/nomenclature/delete', authFilter, (req, res) =>
      @nomenclatureService.delete namespace.company(req), req.body.id, (err) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.NO_CONTENT).end()

module.exports = NomenclatureController
