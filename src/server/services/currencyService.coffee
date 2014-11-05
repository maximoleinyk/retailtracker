i18n = inject('i18n')

class CurrencyService

  constructor: (@currencyStore) ->
    @i18n = i18n.bundle('validation')

  findAll: (callback) ->
    @currencyStore.findAll(callback)

module.exports = CurrencyService