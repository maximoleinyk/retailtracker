i18n = inject('services/i18nService').bundle('validation')

class CompanyService

  constructor: (@companyStore) ->

  findAllOwnedByUser: (userId, callback) ->
    @companyStore.findAllOwnedByUser(userId, callback)

  create: (data, callback) ->
    return callback({ name: i18n.nameRequired }) if not data.name
    return callback({ currencyCode: i18n.currencyCode }) if not data.currencyCode
    return callback({ rate: i18n.currencyRateRequired }) if not data.currencyRate

    @companyStore.create(data, callback)

module.exports = CompanyService