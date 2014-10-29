HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class CompanyController

  constructor: (@companyService) ->

  register: (@router) ->
    @router.get '/company/all', authFilter, (req, res) =>
      @companyService.findAllOwnedByUser 'context', req.user._id, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.get '/company/:id', authFilter, (req, res) =>
      @companyService.findById 'context', req.params.id, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.post '/company/create', authFilter, (req, res) =>
      data = req.body
      data.owner = req.user._id
      @companyService.create 'context', data, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.put '/company/update', authFilter, (req, res) =>
      @companyService.update 'context', req.body, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = CompanyController
