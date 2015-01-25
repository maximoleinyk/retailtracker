AbstractStore = inject('persistence/abstractStore')

class PriceListTemplateStore extends AbstractStore

  findById: ->
    super.populate('currency')

  findAll: ->
    super.populate('currency')

module.exports = PriceListTemplateStore
