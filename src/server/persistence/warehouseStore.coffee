AbstractStore = inject('persistence/abstractStore')

class WarehouseStore extends AbstractStore

  findById: ->
    super.populate('assignee')

  findAll: ->
    super.populate('assignee')

module.exports = WarehouseStore
