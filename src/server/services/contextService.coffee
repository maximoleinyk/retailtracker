namespace = inject('util/namespace')
Promise = inject('util/promise')

class ContextService

  constructor: (@currencyService, @companyStore) ->

  ###
    Create default currency and put currency id into newly created company
  ###
  afterCompanyCreation: (account, company, callback) ->
    companyNamespace = namespace.companyWrapper(account._id, company._id)

    createDefaultCurrency = new Promise (resolve, reject) =>
      currencyData = {
        name: company.currencyCode
        code: company.currencyCode
        rate: company.currencyRate
      }
      @currencyService.create companyNamespace, currencyData, (err, currency) ->
        if err then reject(err) else resolve(currency)

    createDefaultCurrency
    .then (currency) =>
      companyData = company.toJSON()
      companyData.defaultCurrency = currency._id
      new Promise (resolve, reject) =>
        @companyStore.update namespace.accountWrapper(account._id), companyData, (err) ->
          if err then reject(err) else resolve()

    .then(callback)
    .catch(null, callback)

    return createDefaultCurrency

module.exports = ContextService