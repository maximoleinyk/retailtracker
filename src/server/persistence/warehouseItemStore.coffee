AbstractStore = inject('persistence/abstractStore')

class WarehouseItemStore extends AbstractStore

  findBy: (ns, attributes, callback) ->
    @model.get(ns).findOne(attributes, @callback(callback))

  findById: ->
    super.populate('nomenclature warehouse currency')

  findAll: ->
    super.populate('nomenclature warehouse currency')

module.exports = WarehouseItemStore
