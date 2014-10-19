class CompanyService

  constructor: (@companyStore) ->

  findAllOwnedByUser: (userId, callback) ->
    @companyStore.findAllOwnedByUser(userId, callback)

module.exports = CompanyService