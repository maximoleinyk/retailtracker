HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class RoleController

  constructor: (@roleService) ->

  register: (router) ->
    router.get '/role/all', authFilter, (req, res) =>
      @roleService.findAll namespace.account(req), (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.get '/role/:id', authFilter, (req, res) =>
      @roleService.findById namespace.account(req), req.params.id, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.post '/role/create', authFilter, (req, res) =>
      @roleService.create namespace.account(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = RoleController
