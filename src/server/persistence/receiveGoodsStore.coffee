AbstractStore = inject('persistence/abstractStore')

class ReceiveGoodsStore extends AbstractStore

  findById: ->
    super.populate('assignee warehouse warehouseItems')

  findAll: ->
    super.populate('assignee warehouse')

module.exports = ReceiveGoodsStore
