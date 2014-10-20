HttpStatus = require('http-status-codes')
authFilter = inject('util/authFilter')

class CompanyController

  constructor: (@companyService) ->

  register: (@router) ->
    @router.get '/company/all', authFilter, (req, res) =>
      @companyService.findAllOwnedByUser req.user._id, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

    @router.post '/company/create', authFilter, (req, res) =>
      data = req.body
      data.owner = req.user._id
      @companyService.create data, (err, result) ->
        return res.status(HttpStatus.BAD_REQUEST).send(err) if err
        res.status(HttpStatus.OK).send(result)

module.exports = CompanyController
