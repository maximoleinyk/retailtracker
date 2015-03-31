HttpStatus = require('http-status-codes')
_ = require('underscore')
companyFilter = inject('filters/company')
posFilter = inject('filters/pos')
namespace = inject('util/namespace')
Promise = inject('util/promise')

class ContextController

  constructor: (@accountService, @employeeService, @companyService, @posService) ->

  error: (err, res) ->
    res.status(HttpStatus.BAD_REQUEST).send({errors: err})

  register: (router) ->
    router.get '/context/brand', (req, res) =>
      @accountService.findById req.user._id, (err, account) =>
        return res.status(HttpStatus.BAD_REQUEST).send({ error: {generic: err }}) if err
        accountData = account.toJSON()
        delete accountData.password
        res.status(HttpStatus.OK).send(accountData)

    router.get '/context/company', companyFilter, (req, res) =>
      handler = (err, account) =>
        return res.status(HttpStatus.BAD_REQUEST).send({ error: {generic: err }}) if err
        accountData = account.toJSON()
        delete accountData.password
        res.status(HttpStatus.OK).send(accountData)
      @accountService.findById(req.user._id, handler)

    router.get '/context/pos', posFilter, (req, res) =>
      originAccountDetails = {}
      result =
        account: null
        company: null
        employee: null
        pos: null

      loadAccountDetails = new Promise (resolve, reject) =>
        handler = (err, result) =>
          if err then reject(err) else resolve(result)
        @accountService.findById(req.user._id, handler)

      loadAccountDetails
      .then (account) =>
        result.account = account.toJSON()
        delete result.account.password

        originAccountDetails = _.find account.companies.toObject(), (pair) ->
          return pair if pair.company.toString() is req.headers.company

        new Promise (resolve, reject) =>
          accountNamespace = namespace.accountWrapper(originAccountDetails.account)
          @companyService.findById accountNamespace, req.headers.company, (err, result) ->
            if err then reject(err) else resolve(result)

      .then (company) =>
        result.company = company.toJSON()
        new Promise (resolve, reject) =>
          companyNamespace = namespace.companyWrapper(originAccountDetails.account, company._id.toString())
          @employeeService.findByEmail companyNamespace, result.account.login, (err, result) ->
            if err then reject(err) else resolve(result)

      .then (employee) =>
        result.employee = employee.toJSON()
        new Promise (resolve, reject) =>
          companyNamespace = namespace.companyWrapper(originAccountDetails.account, result.company._id.toString())
          @posService.findById companyNamespace, req.headers.pos, (err, result) ->
            if err then reject(err) else resolve(result)

      .then (pos) ->
        result.pos = pos.toJSON()
        res.send(HttpStatus.OK).send(result)
      .catch (err) ->
        res.send(HttpStatus.BAD_REQUEST).send(err)

module.exports = ContextController
