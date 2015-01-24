HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class ProductGroup

  constructor: (@productGroupService) ->

  register: (@router) ->
    @router.get '/productgroup/select/fetch', authFilter, (req, res) =>
      @productGroupService.search namespace.company(req), req.query.q, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.jsonp(result)

    @router.get '/productgroup/all', authFilter, (req, res) =>
      @productGroupService.findAll namespace.company(req), (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.post '/productgroup', authFilter, (req, res) =>
      @productGroupService.create namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.delete '/productgroup/:id', authFilter, (req, res) =>
      @productGroupService.delete namespace.company(req), req.body.id, (err) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.NO_CONTENT).end()

    @router.put '/productgroup/:id', authFilter, (req, res) =>
      @productGroupService.update namespace.company(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = ProductGroup
