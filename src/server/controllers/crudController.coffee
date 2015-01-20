HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class CrudController

  constructor: (@service) ->

  positiveCallback: (res) ->
    (err, result) ->
      return res.status(HttpStatus.BAD_REQUEST).send(err) if err
      res.status(HttpStatus.OK).send(result)

  register: (@router) ->

    # TODO: add selelect/fetch here

    @router.get @baseUrl + '/all', authFilter, (req, res) =>
      @service.findAll namespace.company(req), @positiveCallback(res)

    @router.get @baseUrl + '/:id', authFilter, (req, res) =>
      @service.findById namespace.company(req), req.params.id, @positiveCallback(res)

    @router.post @baseUrl + '/create', authFilter, (req, res) =>
      @service.create namespace.company(req), req.body, @positiveCallback(res)

    @router.put @baseUrl + '/update', authFilter, (req, res) =>
      @service.update namespace.company(req), req.body, @positiveCallback(res)

    @router.delete @baseUrl + '/delete', authFilter, (req, res) =>
      @service.delete namespace.company(req), req.body.id, (err) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.NO_CONTENT).end()

module.exports = CrudController
