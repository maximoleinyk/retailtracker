Model = inject('persistence/model/company')
_ = require('underscore')

class CompanyStore

  constructor: ->
    @model = new Model

  findAll: (ns, callback) ->
    @model.get(ns).find(callback)

  create: (ns, data, callback) ->
    Company = @model.get(ns)

    company = new Company(data)
    company.save(callback)

  update: (ns, data, callback) ->
    @model.get(ns).update({ _id: data._id }, _.omit(data, ['_id']), callback)

  findById: (ns, id, callback) ->
    @model.get(ns).findById(id, callback)

module.exports = CompanyStore