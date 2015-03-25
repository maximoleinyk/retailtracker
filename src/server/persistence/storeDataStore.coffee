AbstractStore = inject('persistence/abstractStore')

class StoreStore extends AbstractStore

  searchField: 'name'

  findById: ->
    super.populate('priceList warehouse manager')

  findAll: ->
    super.populate('priceList warehouse manager')

module.exports = StoreStore

