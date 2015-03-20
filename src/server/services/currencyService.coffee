i18n = inject('util/i18n').bundle('validation')
templates = inject('../../resources/currencies')
AbstractService = inject('services/abstractService')
_ = require('underscore')

class CurrencyService extends AbstractService

  create: (ns, data, callback) ->
    return callback({ name: i18n.nameIsRequired }) if not data.name
    return callback({ code: i18n.codeIsRequired }) if not data.code
    return callback({ rate: i18n.rateIsRequired }) if not data.rate
    return callback({ rate: i18n.rateShouldBeNumeric }) if typeof data.rate isnt 'number'

    data.rate = Math.abs(data.rate)
    super

  delete: (ns, id, callback) ->
    return callback({ generic: i18n.idRequired }) if not id
    super

  update: (ns, data, callback) ->
    return callback({ name: i18n.nameIsRequired }) if not data.name
    return callback({ code: i18n.codeIsRequired }) if not data.code
    return callback({ rate: i18n.rateIsRequired }) if not data.rate
    return callback({ rate: i18n.rateShouldBeNumeric }) if typeof data.rate isnt 'number'

    data.rate = Math.abs(data.rate)
    super

  getCurrencyTemplates: (callback) ->
    callback(null, templates)

module.exports = CurrencyService
