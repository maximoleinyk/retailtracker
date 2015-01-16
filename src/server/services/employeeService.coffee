i18n = inject('util/i18n').bundle('validation')
Promise = inject('util/promise')
namespace = inject('util/namespace')
_ = require('underscore')

class EmployeeService

  constructor: (@companyStore, @roleService, @employeeStore) ->

  findById: (ns, employeeId, callback) ->
    @employeeStore.findById(ns, employeeId, callback)

  findByEmail: (ns, email, callback) ->
    @employeeStore.findByEmail(ns, email, callback)

  findLikeByEmail: (ns, email, callback) ->
    accountId = ns().split('.')[0]

    findAllCompanies = new Promise (resolve, reject) =>
      @companyStore.findAll namespace.accountWrapper(accountId), (err, companies) ->
        if err then reject(err) else resolve(companies)

    findAllCompanies
    .then (companies) =>
      Promise.all _.map companies, (company) =>
        new Promise (resolve, reject) =>
          @employeeStore.findLikeByEmail namespace.companyWrapper(accountId, company._id), email, (err, employees) =>
            if err then reject(err) else resolve(employees)

    .then (result) =>
      employees = []
      _.each result, (employeeArray) ->
        employees = employees.concat(employeeArray)
      callback(null, employees)

    .catch(callback)

  create: (ns, data, callback) ->
    createEmployee = new Promise (resolve, reject) =>
      @employeeStore.create ns, data, (err, result) ->
        if err then reject(err) else resolve(result)

    createEmployee
    .then (result) ->
      callback(null, result)
    .catch(callback)

  update: (ns, data, callback) ->
    # todo implement

  delete: (ns, employeeId, callback) ->
    # todo implement

module.exports = EmployeeService
