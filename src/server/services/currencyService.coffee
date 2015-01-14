i18n = inject('util/i18n').bundle('validation')
templates = inject('../../resources/currencies')

class CurrencyService

  constructor: (@currencyStore) ->

  findAll: (ns, callback) ->
    @currencyStore.findAll(ns, callback)

  create: (ns, data, callback) ->
    return callback({ name: i18n.nameIsRequired }) if not data.name
    return callback({ code: i18n.codeIsRequired }) if not data.code
    return callback({ rate: i18n.rateIsRequired }) if not data.rate
    return callback({ rate: i18n.rateShouldBeNumeric }) if typeof data.rate isnt 'number'

    data.rate = Math.abs(data.rate)

    @currencyStore.create ns, data, (err, result) ->
      return callback({ generic: err }) if err
      callback(null, result)

  delete: (ns, id, callback) ->
    return callback({ generic: i18n.idRequired }) if not id
    @currencyStore.delete ns, id, (err) ->
      return callback({ generic: err }) if err
      callback(null)

  update: (ns, data, callback) ->
    return callback({ name: i18n.nameIsRequired }) if not data.name
    return callback({ code: i18n.codeIsRequired }) if not data.code
    return callback({ rate: i18n.rateIsRequired }) if not data.rate
    return callback({ rate: i18n.rateShouldBeNumeric }) if typeof data.rate isnt 'number'

    data.rate = Math.abs(data.rate)

    @currencyStore.update ns, data, (err) ->
      return callback({ generic: err }) if err
      callback(null, data)

  getCurrencyTemplates: (callback) ->
    callback(null, templates)

module.exports = CurrencyService
