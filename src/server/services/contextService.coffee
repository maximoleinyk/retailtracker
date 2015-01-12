namespace = inject('util/namespace')
Promise = inject('util/promise')
i18n = inject('i18n').bundle('validation')

class ContextService

  constructor: (@currencyService, @companyStore, @roleService) ->

  afterAccountCreation: (account, callback) ->
    accountNamespace = namespace.accountWrapper(account._id)

    createCashierRole = new Promise (resolve, reject) =>
      @roleService.create accountNamespace, { name: i18n.cashier }, (err, result) ->
        if err then reject(err) else resolve(result)

    createManagerRole = new Promise (resolve, reject) =>
      @roleService.create accountNamespace, { name: i18n.manager }, (err, result) ->
        if err then reject(err) else resolve(result)

    createBossRole = new Promise (resolve, reject) =>
      @roleService.create accountNamespace, { name: i18n.boss }, (err, result) ->
        if err then reject(err) else resolve(result)

    Promise.all([createCashierRole, createManagerRole, createBossRole])
    .then (response) =>
      callback(null, response)
    .catch(callback)

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
