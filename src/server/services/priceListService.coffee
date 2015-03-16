_ = require('underscore')
AbstractService = inject('services/abstractService')

class PriceListService extends AbstractService

  generatePrices: (ns, priceListItem, callback) ->
    @templateService.findById ns, priceListItem.priceList, (err, template) =>
      return callback(err) if err

      prices = _.clone(priceListItem)
      templateColumns = template.columns

      # remove cost price column as because we don't need to calculate price for that
      originPrice = templateColumns.unshift()

      delete prices.priceList
      delete prices.nomenclature

      findColumnDetails = (priceListTemplateColumnId) ->
        _.find templateColumns, (column) ->
          column._id is priceListTemplateColumnId

      calculateColumnPrice = (priceListTemplateColumn) ->
        value = .0
        switch priceListTemplateColumn.type
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

  delete: (ns, id, callback) ->
    @findById ns, id, (err, document) =>
      data = document.toJSON()
      data.template = data.template._id
      data.state = 'DELETED'
      @update(ns, data, callback)

  activate: (ns, id, callback) ->
    @findById ns, id, (err, document) ->
      return callback(err) if err
      data = document.toJSON()
      data.template = data.template._id
      data.state = 'ACTIVATED'
      @update(ns, data, callback)

module.exports = PriceListService
