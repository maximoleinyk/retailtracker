HttpStatus = require('http-status-codes')
CrudController = inject('controllers/crudController')
companyFilter = inject('filters/company')
namespace = inject('util/namespace')

class PosController extends CrudController

  baseUrl: '/pos'
  filter: companyFilter
  namespace: namespace.company

  register: (router) ->
    super

    router.post @baseUrl + '/allowed', @filter, (req, res) =>
      @service.fetchAllowed(@namespace(req), req.body, @callback(res))

    router.post @baseUrl + '/start', @filter, (req, res) =>
      @service.start @namespace(req), req.body, (err, pos) ->
        return res.status(401).end('Not authorised for this pos') if err
        req.session.pos = pos._id
        res.status(200).send(pos)

module.exports = PosController
