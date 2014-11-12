HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')
accountNamespace = inject('util/namespace/account')

class CompanyController

  constructor: (@companyService) ->

  register: (@router) ->
    @router.get '/company/all', authFilter, (req, res) =>
      @companyService.findAll req.user.owner, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.get '/company/:id', authFilter, (req, res) =>
      @companyService.findById accountNamespace(req), req.params.id, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.get '/company/invite/:key', (req, res) =>
      key = req.params.key
      @companyService.getInvitedCompanyDetails key, (err, company) =>
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(company)

    @router.post '/company/create', authFilter, (req, res) =>
      @companyService.create accountNamespace(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.put '/company/update', authFilter, (req, res) =>
      @companyService.update accountNamespace(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = CompanyController
