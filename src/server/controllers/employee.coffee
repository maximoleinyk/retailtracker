HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class EmployeeController

  constructor: (@employeeService) ->

  register: (router) ->
    router.get '/employees/fetch', authFilter, (req, res) =>
      match = req.query.match or ''
      @employeeService.findLikeByEmail namespace.company(req), match, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.get '/employees/:id', authFilter, (req, res) =>
      @employeeService.findById namespace.company(req), req.param('id'), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.post '/employees/create', authFilter, (req, res) =>
      @employeeService.create namespace.company(req), req.body, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.put '/employees/:id', authFilter, (req, res) =>
      @employeeService.update namespace.company(req), req.body, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.delete '/employees/:id', authFilter, (req, res) =>
      @employeeService.delete namespace.company(req), req.param('id'), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

module.exports = EmployeeController
