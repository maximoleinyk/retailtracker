Model = inject('persistence/model/warehouse')
AbstractStore = inject('persistence/abstractStore')

class WarehouseStore extends AbstractStore

  constructor: ->
    @model = new Model

module.exports = WarehouseStore
