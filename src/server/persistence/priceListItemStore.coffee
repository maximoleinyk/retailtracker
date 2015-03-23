AbstractStore = inject('persistence/abstractStore')

class PriceListItemStore extends AbstractStore

  findAllByPriceListId: (ns, priceListId, callback) ->
    @model.get(ns).find({priceList: priceListId}, @callback(callback)).populate('nomenclature')

  findById: ->
    super.populate('nomenclature priceList')

  findAll: ->
    super.populate('nomenclature')

module.exports = PriceListItemStore
