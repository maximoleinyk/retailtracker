HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')
ReadableController = inject('controllers/readableController')

class CrudController extends ReadableController

  register: (router) ->
    super

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
