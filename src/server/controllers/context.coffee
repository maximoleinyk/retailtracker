HttpStatus = require('http-status-codes')
_ = require('underscore')
companyFilter = inject('filters/company')
posFilter = inject('filters/pos')
namespace = inject('util/namespace')
Promise = inject('util/promise')

class ContextController

  constructor: (@accountService, @employeeService, @companyService, @posService, @roleService) ->

  findCompany: (companies, companyId) ->
    _.find companies, (pair) ->
      return pair if pair.company.toString() is companyId

  populate: (req, result) ->
    loadAccountDetails = new Promise (resolve, reject) =>
      handler = (err, result) =>
        if err then reject(err) else resolve(result)
      @accountService.findById(req.user._id, handler)

    loadAccountDetails
    .then (account) =>
      result.account = account.toJSON()
      delete result.account.password

      new Promise (resolve, reject) =>
        originAccountDetails = @findCompany(result.account.companies, req.session.company)
        accountNamespace = namespace.accountWrapper(originAccountDetails.account)
        @companyService.findById accountNamespace, req.session.company, (err, result) ->
          if err then reject(err) else resolve(result)

    .then (company) =>
      result.company = company.toJSON()
      new Promise (resolve, reject) =>
        originAccountDetails = @findCompany(result.account.companies, req.session.company)
        companyNamespace = namespace.companyWrapper(originAccountDetails.account, company._id.toString())
        @employeeService.findByEmail companyNamespace, result.account.login, (err, result) ->
          if err then reject(err) else resolve(result)

  register: (router) ->

    # context data for account module
    router.get '/context/brand', (req, res) =>
      @accountService.findById req.user._id, (err, account) =>
        return res.status(HttpStatus.BAD_REQUEST).send({ error: {generic: err }}) if err
        accountData = account.toJSON()
        delete accountData.password
        res.status(HttpStatus.OK).send(accountData)

    # context data for company module
    router.get '/context/company', companyFilter, (req, res) =>
      result = {
        account: null
        company: null
        employee: null
      }

      @populate(req, result)
      .then (employee) =>
        result.employee = employee.toJSON()
        new Promise (resolve, reject) =>
          ns = namespace.accountWrapper(@findCompany(result.account.companies, req.session.company).account)
          @roleService.findById ns, employee.role, (err, result) ->
            if err then reject(err) else resolve(result)

      .then (role) ->
        result.employee.role = role.toJSON()
        res.status(HttpStatus.OK).send(result)

      .catch (err) ->
        res.status(HttpStatus.BAD_REQUEST).send(err)

    # context data for pos module
    router.get '/context/pos', posFilter, (req, res) =>
      result = {
        account: null
        company: null
        employee: null
        pos: null
      }

      @populate(req, result)
      .then (employee) =>
        result.employee = employee.toJSON()
        new Promise (resolve, reject) =>
          companyId = result.company._id.toString()
          originAccountDetails = @findCompany(result.account.companies, companyId)
          companyNamespace = namespace.companyWrapper(originAccountDetails.account, companyId)
          @posService.findById companyNamespace, req.headers.pos, (err, result) ->
            if err then reject(err) else resolve(result)

      .then (pos) ->
        result.pos = pos.toJSON()
        res.status(HttpStatus.OK).send(result)

      .catch (err) ->
        res.status(HttpStatus.BAD_REQUEST).send(err)

module.exports = ContextController
