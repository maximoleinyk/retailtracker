AbstractStore = inject('persistence/abstractStore')

class PosStore extends AbstractStore

  findById: ->
    super.populate('store cashiers')

  findAll: ->
    super.populate('store cashiers')

module.exports = PosStore
