Model = inject('persistence/model/pos')
AbstractStore = inject('persistence/abstractStore')

class PosStore extends AbstractStore

  constructor: ->
    @model = new Model

module.exports = PosStore
