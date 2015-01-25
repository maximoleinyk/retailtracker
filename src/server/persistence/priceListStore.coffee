AbstractStore = inject('persistence/abstractStore')

class PriceListStore extends AbstractStore

  findById: ->
    super.populate('template')

  findAll: ->
    super.populate('template')

module.exports = PriceListStore
