AbstractStore = inject('persistence/abstractStore')

class PosStore extends AbstractStore

  findById: ->
    super.populate('store cashiers')

  findAll: ->
    super.populate('store cashiers')

  findAllowedPos: (ns, employeeId, storeId, callback) ->
    criteria = {
      store: storeId
      cashiers:
        $in: [employeeId]
    }
    @model.get(ns).find(criteria, @callback(callback))

module.exports = PosStore
