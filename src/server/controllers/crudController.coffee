HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class CrudController

  namespace: namespace.root
  baseUrl: ''

  constructor: (@service) ->

  filter: (req, res, next) ->
    next()

  callback: (res) ->
    (err, result) ->
      if err then res.status(HttpStatus.BAD_REQUEST).send({errors: err}) else res.status(HttpStatus.OK).send(result)

  register: (router) ->
    router.get @baseUrl + '/select/fetch', @filter, (req, res) =>
      @service.search @namespace(req), req.query.q, req.query.l, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).jsonp(result)

    router.get @baseUrl + '/all', @filter, (req, res) =>
      @service.findAll @namespace(req), @callback(res)

    router.get @baseUrl + '/:id', @filter, (req, res) =>
      @service.findById @namespace(req), req.params.id, @callback(res)

    router.post @baseUrl, @filter, (req, res) =>
      @service.create @namespace(req), req.body, @callback(res)

    router.put @baseUrl + '/:id', @filter, (req, res) =>
      @service.update @namespace(req), req.body, @callback(res)

    router.delete @baseUrl + '/:id', @filter, (req, res) =>
      @service.delete @namespace(req), req.param('id'), (err) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send({errors: err}) else res.status(HttpStatus.NO_CONTENT).end()

module.exports = CrudController
