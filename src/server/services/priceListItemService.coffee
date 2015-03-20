_ = require('underscore')
AbstractService = inject('services/abstractService')

class PriceListItemService extends AbstractService

  findAllByPriceListId: (ns, priceListId, callback) ->
    @store.findAllByPriceListId(ns, priceListId, callback)

  generatePrices: (ns, priceListItem, callback) ->
    @formulaService.findById ns, priceListItem.priceList, (err, formula) =>
      return callback(err) if err

      prices = _.clone(priceListItem)
      formulaColumns = formula.columns

      # remove cost price column as because we don't need to calculate price for that
      originPrice = formulaColumns.unshift()

      delete prices.priceList
      delete prices.nomenclature

      findColumnDetails = (formulaColumnId) ->
        _.find formulaColumns, (column) ->
          column._id is formulaColumnId

      calculateColumnPrice = (formulaColumn) ->
        value = .0
        switch formulaColumn.type
          when 'PERCENT' then value = 0
          when 'FIXED' then value = 0
          else
            value = 0
        value

      result =
        nomenclature: prices.nomenclature

      _.each prices, (value, key) ->
        details = findColumnDetails(key)
        columnPrice = calculateColumnPrice(details)
        result[key] = columnPrice

      callback(null, result)

module.exports = PriceListItemService
