HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class EmployeeController

  constructor: (@employeeService) ->

  register: (router) ->
    router.get '/employees/all', authFilter, (req, res) =>
      @employeeService.findAll namespace.account(req), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.get '/employees/all/:companyId', authFilter, (req, res) =>
      @employeeService.findAllByCompanyId namespace.account(req), req.param('companyId'), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.get '/employees/:id', authFilter, (req, res) =>
      @employeeService.findById namespace.account(req), req.param('id'), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.post '/employees/create', authFilter, (req, res) =>
      @employeeService.create namespace.account(req), req.body, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.put '/employees/:id', authFilter, (req, res) =>
      @employeeService.update namespace.account(req), req.body, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.delete '/employees/:id', authFilter, (req, res) =>
      @employeeService.delete namespace.account(req), req.param('id'), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

module.exports = EmployeeController
