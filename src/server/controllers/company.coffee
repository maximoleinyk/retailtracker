HttpStatus = require('http-status-codes')
namespace = inject('util/namespace')

class CompanyController

  constructor: (@companyService) ->

  register: (router) ->
    router.post '/company/start', (req, res) =>
      @companyService.findById namespace.account(req), req.body.id, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        req.session.company = result._id
        res.status(HttpStatus.OK).send(result)

    router.post '/company/:companyId/permission/:userId', (req, res) =>
      @companyService.checkPermission req.params.companyId, req.params.userId, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.get '/company/all', (req, res) =>
      @companyService.findAll req.user.owner, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.get '/company/:id', (req, res) =>
      @companyService.findById namespace.account(req), req.params.id, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.get '/company/invite/:key', (req, res) =>
      key = req.params.key
      @companyService.getInvitedCompanyDetails key, (err, company) =>
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(company)

    router.post '/company', (req, res) =>
      @companyService.create namespace.account(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    router.put '/company/:id', (req, res) =>
      @companyService.update namespace.account(req), req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = CompanyController
