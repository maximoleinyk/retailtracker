i18nService = inject('services/i18nService')

class CurrencyService

  constructor: (@currencyStore) ->
    @i18n = i18nService.bundle('validation')

  findAll: (callback) ->
    @currencyStore.findAll(callback)

module.exports = CurrencyService