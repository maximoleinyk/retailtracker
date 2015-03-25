Promise = inject('util/promise')
namespace = inject('util/namespace')
AbstractService = inject('services/abstractService')
_ = require('underscore')

class EmployeeService extends AbstractService

  constructor: (@store, @companyStore) ->

  findByEmail: (ns, email, callback) ->
    @store.findByEmail(ns, email, callback)

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
          @store.findLikeByEmail namespace.companyWrapper(accountId,
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

module.exports = EmployeeService
