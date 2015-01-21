HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class CrudController

  baseUrl: ''

  constructor: (@namespace = namespace.root, @service) ->

  callback: (res) ->
    (err, result) ->
      if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

  register: (router) ->
    router.get @baseUrl + '/all', authFilter, (req, res) =>
      @service.findAll @namespace(req), @callback(res)

    router.get @baseUrl + '/:id', authFilter, (req, res) =>
      @service.findById @namespace(req), req.params.id, @callback(res)

    router.post @baseUrl, authFilter, (req, res) =>
      @service.create @namespace(req), req.body, @callback(res)

    router.put @baseUrl + '/:id', authFilter, (req, res) =>
      @service.update @namespace(req), req.body, @callback(res)

    router.delete @baseUrl + '/:id', authFilter, (req, res) =>
      @service.delete @namespace(req), req.body.id, (err) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.NO_CONTENT).end()

module.exports = CrudController