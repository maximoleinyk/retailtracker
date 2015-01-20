Model = inject('persistence/model/store')
AbstractStore = inject('persistence/abstractStore')

class StoreStore extends AbstractStore

  constructor: ->
    @model = new Model

module.exports = StoreStore

