_ = require('underscore')
AbstractService = inject('services/abstractService')
Promise = inject('util/promise')
i18n = inject('util/i18n').bundle('validation')
numeral = require('numeral')

class PriceListItemService extends AbstractService

  constructor: (@store, @formulaStore) ->
    super

  findAllByPriceListId: (ns, priceListId, callback) ->
    @store.findAllByPriceListId(ns, priceListId, callback)

  create: (ns, data, callback) ->
    return callback({nomenclature: 'Nomenclature is required'}) if not data.nomenclature
    return callback({priceList: 'Price list is required'}) if not data.priceList
    clonedData = _.omit(_.clone(data), ['nomenclature', 'priceList', 'id'])
    zeroPriceIds = {}
    _.each clonedData, (price, id) ->
      if not price
        zeroPriceIds[id] = i18n.priceShouldBeSpecified
        return false
    return callback(zeroPriceIds) if not _.isEmpty(zeroPriceIds)
    super

  update: (ns, data, callback) ->
    return callback({nomenclature: 'Nomenclature is required'}) if not data.nomenclature
    return callback({priceList: 'Price list is required'}) if not data.priceList
    clonedData = _.omit(_.clone(data), ['nomenclature', 'priceList', 'id'])
    zeroPriceIds = {}
    _.each clonedData, (price, id) ->
      if not price
        zeroPriceIds[id] = i18n.priceShouldBeSpecified
        return false
    return callback(zeroPriceIds) if not _.isEmpty(zeroPriceIds)
    super

  generatePrices: (ns, data, callback) ->
    return callback({ priceList: 'Price list id is required' }) if not data.priceList
    return callback({ formula: 'Formula id is required' }) if not data.formula
    return callback({ nomenclature: 'Nomenclature should be specified' }) if not data.nomenclature

    findFormula = new Promise (resolve, reject) =>
      @formulaStore.findById ns, data.formula, (err, result) ->
        if err then reject(err) else resolve(result)

    findFormula.then (formula) =>
      throw 'There is no such formula' if not formula
      result = _.clone(_.omit(data, ['priceList', 'formula', 'nomenclature', 'id']))
      originPrice = data[formula.columns.shift()._id.toString()]
      _.each formula.columns, (formulaColumn) ->
        price = numeral(originPrice)
        switch formulaColumn.type
          when 'PERCENT' then price.add(numeral(price).divide(100).multiply(formulaColumn.amount))
          else
            price.add(formulaColumn.amount)
        result[formulaColumn._id.toString()] = price.value()
      callback(null, result)

    .catch(callback)

module.exports = PriceListItemService
