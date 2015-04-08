_ = require('underscore')
AbstractService = inject('services/abstractService')
Promise = inject('util/promise')
numeral = require('numeral')
moment = require('moment')
i18n = inject('util/i18n').bundle('validation')

class ReceiveGoodsService extends AbstractService

  constructor: (@store, @warehouseItemService, @currencyStore, @nomenclatureStore) ->

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

  enter: (ns, data, callback) ->
    return callback({status: i18n.documentAlreadyEntered}) if data.status is 'ENTERED'

    find = new Promise (resolve, reject) =>
      @findById ns, data.id, (err, result) =>
        if err then reject(err) else resolve(result)

    find.then (document) =>
      data = document.toJSON()
      data.status = 'ENTERED'
      data.entered = moment().toDate()
      data.warehouse = data.warehouse._id
      data.currency = data.currency._id
      data.assignee = data.assignee._id
      _.each data.items, (item) ->
        item.nomenclature = item.nomenclature._id

      new Promise (resolve, reject) =>
        @update ns, data, (err, result) ->
          if err then reject(err) else resolve(result)

    .then (document) =>
      createAllItems = _.map document.items, (rawItem) =>
        productItem = {
          nomenclature: rawItem.nomenclature._id
          quantity: rawItem.quantity
          warehouse: document.warehouse._id
          currency: document.currency._id
          currencyCode: document.currencyCode
          currencyRate: document.currencyRate
          price: rawItem.price
        }
        new Promise (resolve, reject) =>
          @warehouseItemService.create ns, productItem, (err) ->
            if err then reject(err) else resolve()

      Promise.all(createAllItems).then ->
        new Promise (resolve) ->
          resolve(document)

    .then (document) ->
      callback(null, document)

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
