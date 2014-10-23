Company = inject('persistence/model/company')

class CompanyStore

  findAllOwnedByUser: (userId, callback) ->
    Company.find({ owner: userId }, callback)

  create: (data, callback) ->
    company = new Company(data)
    company.save(callback)

  findById: (id, callback) ->
    Company.findById(id, callback)

module.exports = CompanyStore