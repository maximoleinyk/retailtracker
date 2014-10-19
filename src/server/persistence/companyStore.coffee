Company = inject('persistence/model/company')

class CompanyStore

  findAllOwnedByUser: (userId, callback) ->
    Company.find({ owner: userId }, callback)

module.exports = CompanyStore