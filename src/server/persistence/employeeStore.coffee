Model = inject('persistence/model/employee')
_ = require('underscore')

class EmployeeStore

  constructor: ->
    @model = new Model

  findById: (ns, id, callback) ->
    @model.get(ns).findById(id, callback)

  findByEmail: (ns, email, callback) ->
    @model.get(ns).findOne({ email: email }, callback)

  findAll: (ns, callback) ->
    @model.get(ns).find({}, callback)

  create: (ns, data, callback) ->
    Employee = @model.get(ns)

    employee = new Employee(data)
    employee.save(callback)

  update: (ns, data, callback) ->
    @model.get(ns).update({_id: data.id or data._id}, _.omit(data, ['_id']), callback)

  delete: (ns, id, callback) ->
    @model.get(ns).findByIdAndRemove(id, callback)

module.exports = EmployeeStore
