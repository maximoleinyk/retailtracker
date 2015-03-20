AbstractStore = inject('persistence/abstractStore')

class PriceListItemStore extends AbstractStore

  findAllByPriceListId: (ns, priceListId, callback) ->
    @model.get(ns).find({priceList: priceListId}, @callback(callback)).populate('nomenclature priceList')

  findById: ->
    super.populate('nomenclature priceList')

  findAll: ->
    super.populate('nomenclature priceList')

module.exports = PriceListItemStore
