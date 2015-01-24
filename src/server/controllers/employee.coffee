HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
namespace = inject('util/namespace')

class EmployeeController

  constructor: (@employeeService) ->

  register: (router) ->
    router.get '/employees/all/:accountId/:companyId', authFilter, (req, res) =>
      @employeeService.findAll namespace.companyWrapper(req.param('accountId'), req.param('companyId')), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.get '/employees/fetch', authFilter, (req, res) =>
      match = req.query.match or ''
      limit = req.query.limit or 5
      @employeeService.findLikeByEmail namespace.company(req), match, limit, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.get '/employees/select/fetch', authFilter, (req, res) =>
      @employeeService.search namespace.company(req), req.query.q, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).jsonp(result)

    router.get '/employees/:id', authFilter, (req, res) =>
      @employeeService.findById namespace.company(req), req.param('id'), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.post '/employees', authFilter, (req, res) =>
      @employeeService.create namespace.company(req), req.body, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.put '/employees/:id', authFilter, (req, res) =>
      @employeeService.update namespace.company(req), req.body, (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

    router.delete '/employees/:id', authFilter, (req, res) =>
      @employeeService.delete namespace.company(req), req.param('id'), (err, result) ->
        if err then res.status(HttpStatus.BAD_REQUEST).send(err) else res.status(HttpStatus.OK).send(result)

module.exports = EmployeeController
