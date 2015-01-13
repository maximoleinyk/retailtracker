i18n = inject('i18n').bundle('validation')
Promise = inject('util/promise')

class EmployeeService

  constructor: (@employeeStore) ->

  findById: (ns, employeeId, callback) ->
    @employeeStore.findById(ns, employeeId, callback)

  findAll: (ns, callback) ->
    @employeeStore.findAll(ns, callback)

  findAllByCompanyId: (ns, callback) ->
    # todo implement

  create: (ns, data, callback) ->
    # todo implement

  update: (ns, data, callback) ->
    # todo implement

  delete: (ns, employeeId, callback) ->
    # todo implement

module.exports = EmployeeService
