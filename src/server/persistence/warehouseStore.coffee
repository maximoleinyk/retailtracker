Model = inject('persistence/model/warehouse')
_ = require('underscore')

class WarehouseStore

  constructor: ->
    @model = new Model

  create: (ns, data, callback) ->
    Warehouse = @model.get(ns)

    warehouse = new Warehouse(data)
    warehouse.save(callback)

  delete: (ns, id, callback) ->
    @model.get(ns).findByIdAndRemove(id, callback)

  update: (ns, data, callback) ->
    @model.get(ns).update({_id: data._id or data.id}, _.omit(data, ['_id']), callback)

  findById: (ns, id, callback) ->
    @model.get(ns).findById(id, callback)

  findAll: (ns, callback) ->
    @model.get(ns).find({}, callback)

module.exports = WarehouseStore