i18n = inject('util/i18n').bundle('validation')
Promise = inject('util/promise')

class EmployeeService

  constructor: (@employeeStore) ->

  findById: (ns, employeeId, callback) ->
    @employeeStore.findById(ns, employeeId, callback)

  findByEmail: (ns, email, callback) ->
    @employeeStore.findByEmail(ns, email, callback)

  findAll: (ns, callback) ->
    @employeeStore.findAll(ns, callback)

  findAllByCompanyId: (ns, callback) ->
    # todo implement

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
