HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class RoleController

  constructor: (@roleService) ->

  register: (router) ->
    router.get '/roles/all', authFilter, (req, res) =>
      @roleService.findAll namespace.account(req), (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.get '/roles/all/available', authFilter, (req, res) =>
      @roleService.findAllAvailable namespace.account(req), (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.get '/roles/:id/account/:accountId', authFilter, (req, res) =>
      @roleService.findById namespace.accountWrapper(req.params.accountId), req.params.id, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = RoleController
