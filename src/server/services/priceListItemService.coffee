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

  generatePrices: (ns, data, callback) ->
    return callback({ priceList: 'Price list id is required' }) if not data.priceList
    return callback({ formula: 'Formula id is required' }) if not data.formula
    return callback({ nomenclature: 'Nomenclature should be specified' }) if not data.nomenclature

    findFormula = new Promise (resolve, reject) =>
      @formulaStore.findById ns, data.formula, (err, result) ->
        if err then reject(err) else resolve(result)

    findFormula.then (formula) =>
      result = _.clone(_.omit(data, ['priceList', 'formula', 'nomenclature']))
      originPrice = numeral(data[formula.columns.shift()._id.toString()])
      _.each formula.columns, (formulaColumn) ->
        switch formulaColumn.type
          when 'PERCENT' then originPrice.add(originPrice.divide(100).multiply(formulaColumn.amount))
          else
            originPrice.add(formulaColumn.amount)
        result[formulaColumn._id.toString()] = originPrice.value()
      callback(null, result)

    .catch(callback)

module.exports = PriceListItemService
