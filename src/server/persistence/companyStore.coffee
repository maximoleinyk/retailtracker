Model = inject('persistence/model/company')

class CompanyStore

  constructor: ->
    @model = new Model

  findAll: (ns, callback) ->
    @model.get(ns).find(callback)

  create: (ns, data, callback) ->
    Company = @model.get(ns)

    company = new Company(data)
    company.save(callback)

  findById: (ns, id, callback) ->
    @model.get(ns).findById(id, callback)

module.exports = CompanyStore