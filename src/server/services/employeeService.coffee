i18n = inject('util/i18n').bundle('validation')
Promise = inject('util/promise')
namespace = inject('util/namespace')
_ = require('underscore')

class EmployeeService

  constructor: (@companyStore, @roleService, @employeeStore) ->

  search: (ns, query, callback) ->
    query = query or ''
    @findAll ns, (err, all) ->
      results = _.filter all, (item) ->
        item.firstName.toLowerCase().indexOf(query.toLowerCase()) > -1 or item.lastName.toLowerCase().indexOf(query.toLowerCase()) > -1
      results = results.splice(0, 5)
      callback(err, results)

  findById: (ns, employeeId, callback) ->
    @employeeStore.findById(ns, employeeId, callback)

  findByEmail: (ns, email, callback) ->
    @employeeStore.findByEmail(ns, email, callback)

  findAll: (ns, callback) ->
    findAll = new Promise (resolve, reject) =>
      @employeeStore.findAll ns, (err, employees) ->
        if err then reject(err) else resolve(employees)

    findAll.then (employees) =>
      Promise.all _.map employees, (employee) =>
        new Promise (resolve, reject) =>
          @roleService.findById namespace.accountWrapper(ns().split('.')[0]), employee.role, (err, role) ->
            return reject(err) if err
            employeeData = employee.toJSON()
            employeeData.role = role.toJSON()
            resolve(employeeData)

    .then (employees) ->
      callback(null, employees)

    .catch(callback)

  findLikeByEmail: (ns, email, limit, callback) ->
    accountId = ns().split('.')[0]

    findAllCompanies = new Promise (resolve, reject) =>
      handler = (err, companies) ->
        if err then reject(err) else resolve(companies)
      @companyStore.findAll(namespace.accountWrapper(accountId), handler).populate('owner')

    findAllCompanies
    .then (companies) =>
      Promise.all _.map companies, (company) =>
        new Promise (resolve, reject) =>
          @employeeStore.findLikeByEmail namespace.companyWrapper(accountId,
            company._id), email, limit, (err, employees) =>
            employees = _.filter employees, (employee) ->
              employee.email isnt company.owner.email
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
