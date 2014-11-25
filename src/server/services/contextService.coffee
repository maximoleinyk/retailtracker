namespace = inject('util/namespace')
Promise = inject('util/promise')

class ContextService

  constructor: (@currencyService) ->

  afterAccountCreation: (accountData, callback) ->
    # create roles Manager, Cashier

  afterCompanyCreation: (account, company, callback) ->
    companyNamespace = namespace.companyWrapper(account._id, company._id)

    createDefaultCurrency = new Promise (resolve, reject) =>
      currencyData = {
        name: company.currencyCode
        code: company.currencyCode
        rate: company.currencyRate
      }
      @currencyService.create companyNamespace, currencyData, (err) ->
        if err then reject(err) else resolve()

    createDefaultCurrency
    .then(callback)
    .catch(null, callback)

    return createDefaultCurrency

module.exports = ContextService