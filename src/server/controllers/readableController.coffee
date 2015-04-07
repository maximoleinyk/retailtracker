HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class ReadableController

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

module.exports = ReadableController
