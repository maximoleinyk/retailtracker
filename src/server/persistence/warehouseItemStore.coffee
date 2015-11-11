AbstractStore = inject('persistence/abstractStore')
mongoose = require('mongoose')
_ = require('underscore')

class WarehouseItemStore extends AbstractStore

  findBy: (ns, attributes, callback) ->
    @model.get(ns).findOne(attributes, @callback(callback))

  countRemainingCommodities: (ns, warehouseId, nomenclatureIds = [], callback) ->
    config = [
      {
        $match:
          warehouse: if warehouseId then new mongoose.Types.ObjectId(warehouseId) else null
      },
      {
        $group:
          _id: '$nomenclature'
          remainingCommodity:
            $sum: '$quantity'
          count:
            $sum: 1
      }
    ]
    @model.get(ns).aggregate(config).exec(@callback(callback))

  countRemainingCommodity: (ns, warehouseId, nomenclatureId, callback) ->
    match = {
      nomenclature: new mongoose.Types.ObjectId(nomenclatureId)
    }
    match.warehouse = new mongoose.Types.ObjectId(warehouseId) if warehouseId
    config = [
      {
        $match: match
      },
      {
        $group:
          _id: null
          remainingCommodity:
            $sum: '$quantity'
          count:
            $sum: 1
      }
    ]
    @model.get(ns).aggregate(config).exec(@callback(callback))

  findById: ->
    super.populate('nomenclature warehouse currency')

  findAll: ->
    super.populate('nomenclature warehouse currency')

module.exports = WarehouseItemStore
