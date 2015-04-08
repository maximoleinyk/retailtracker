AbstractService = inject('services/abstractService')
numeral = require('numeral')
Promise = inject('util/promise')
_ = require('underscore')

class WarehouseService extends AbstractService

  getCommodity: (ns, data, callback) ->
    @store.countRemainingCommodity ns, data.warehouse, data.nomenclature, (err, result) ->
      if err then callback(err) else callback(null, (result[0] || {}))

  getItemsCommodity: (ns, data, callback) ->
    @store.countRemainingCommodities(ns, data.warehouse, data.nomenclatures, callback)

  create: (ns, data, callback) ->
    errors = {}
    errors.nomenclature = i18n.nomenclatureIsRequired if not data.nomenclature
    errors.warehouse = i18n.warehouseIsRequired if not data.warehouse
    errors.price = i18n.priceIsRequired if not data.price
    errors.currency = i18n.currencyIsRequired if not data.currency
    errors.currencyRate = i18n.currencyRateIsRequired if not data.currencyRate
    errors.currencyCode = i18n.currencyCodeIsRequired if not data.currencyCode
    return callback(errors) if not _.isEmpty(errors)

    findExisting = new Promise (resolve, reject) =>
      attributes = {
        nomenclature: data.nomenclature
        warehouse: data.warehouse
        price: data.price
        currency: data.currency
        currencyRate: data.currencyRate
        currencyCode: data.currencyCode
      }
      @store.findBy ns, attributes, (err, result) ->
        if err then reject(err) else resolve(result)

    findExisting.then (found) =>
      new Promise (resolve, reject) =>
        cb = (err, result) ->
          if err then reject(err) else resolve(result)

        if found
          updatedData = found.toJSON()
          updatedData.quantity = numeral(updatedData.quantity).add(data.quantity).value()
          @store.update(ns, updatedData, cb)
        else
          @store.create(ns, data, cb)

    .then (item) ->
      callback(null, item)

    .catch(callback)

module.exports = WarehouseService
