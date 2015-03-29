HttpStatus = require('http-status-codes')
CrudController = inject('controllers/crudController')
authFilter = inject('util/authFilter')

class PosController extends CrudController

  baseUrl: '/pos'

  register: (router) ->
    super

    router.post @baseUrl + '/allowed', authFilter, (req, res) =>
      @service.fetchAllowed(@namespace(req), req.body, @callback(res))

    router.post @baseUrl + '/start', authFilter, (req, res) =>
      @service.start @namespace(req), req.body, (err, pos) ->
        return res.status(401).end('Not authorised for this pos') if err
        req.session.pos = pos._id
        res.status(200).send(pos)

module.exports = PosController
