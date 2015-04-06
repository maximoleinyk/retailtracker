_ = require('underscore')
AbstractService = inject('services/abstractService')
Promise = inject('util/promise')
numeral = require('numeral')
i18n = inject('util/i18n').bundle('validation')

class ReceiveGoodsService extends AbstractService

  constructor: (@store, @currencyStore, @nomenclatureStore) ->

  updateTotals: (ns, data, callback) ->
    quantityIterator = (total, item) ->
      numeral(total).add(item.quantity).value()
    priceIterator = (total, item) ->
      numeral(total).add(item.totalPrice).value()

    data.totalQuantity = _.reduce(data.items, quantityIterator, 0)
    data.totalPrice = _.reduce(data.items, priceIterator, 0)

    promises = _.map _.pluck(data.items, 'nomenclature'), (nomenclatureId) =>
      new Promise (resolve, reject) =>
        @nomenclatureStore.findById ns, nomenclatureId, (err, result) ->
          if err then reject(err) else resolve(result)

    Promise.all(promises)
    .then (result) ->
      _.each data.items, (item) ->
        item.nomenclature = _.find result, (document) ->
          document._id.toString() is item.nomenclature
      callback(null, data)

    .catch(callback)

  create: (ns, data, callback) ->
    errors = {}
    errors.number = i18n.nuumberIsRequired if not data.number
    errors.assignee = i18n.assigneeIsRequired if not data.assignee
    errors.warehouse = i18n.warehouseIsRequired if not data.warehouse
    errors.currency = i18n.currencyIsRequired if not data.currency
    errors.items = i18n.pleaseAddOneOrMoreProducts if not data.items.length
    return callback(errors) if not _.isEmpty(errors)

    findCurrency = new Promise (resolve, reject) =>
      @currencyStore.findById ns, data.currency, (err, result) ->
        if err then reject(err) else resolve(result)

    findCurrency
    .then (currency) =>
      data.currencyCode = currency.code
      data.currencyRate = currency.rate
      AbstractService::create.call(this, ns, data, callback)

    .catch(callback)

  update: (ns, data, callback) ->
    errors = {}
    errors.number = i18n.nuumberIsRequired if not data.number
    errors.assignee = i18n.assigneeIsRequired if not data.assignee
    errors.warehouse = i18n.warehouseIsRequired if not data.warehouse
    errors.currency = i18n.currencyIsRequired if not data.currency
    errors.items = i18n.pleaseAddOneOrMoreProducts if not data.items.length
    return callback(errors) if not _.isEmpty(errors)

    findCurrency = new Promise (resolve, reject) =>
      @currencyStore.findById ns, data.currency, (err, result) ->
        if err then reject(err) else resolve(result)

    findCurrency.then (currency) =>
      data.currencyCode = currency.code
      data.currencyRate = currency.rate
      AbstractService::update.call(this, ns, data, callback)

    .catch(callback)

  enter: (ns, id, callback) ->
    find = new Promise (resolve, reject) =>
      @findById ns, id, (err, result) =>
        if err then reject(err) else resolve(result)

    find.then (document) =>
      data = document.toJSON()
      data.status = 'ENTERED'

      data.totalQuantity = _.reduce data.items, (total, item) ->
        numeral(total).add(item.quantity).value()

      data.totalPrice = _.reduce data.items, (total, item) ->
        numeral(total).add(item.totalPrice).value()

      @update(ns, data, callback)

    .catch(callback)

  delete: (ns, id, callback) ->
    find = new Promise (resolve, reject) =>
      @findById ns, id, (err, result) =>
        if err then reject(err) else resolve(result)

    find.then (document) =>
      data = document.toJSON()
      data.status = 'DELETED'
      @update(ns, data, callback)

    .catch(callback)

module.exports = ReceiveGoodsService
