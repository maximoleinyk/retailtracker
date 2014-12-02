Model = inject('persistence/model/productGroup')
_ = require('underscore')

class ProductGroupStore

  constructor: ->
    @model = new Model

  create: (ns, data, callback) ->
    ProductGroup = @model.get(ns)

    productGroup = new ProductGroup(data)
    productGroup.save(callback)

  delete: (ns, id, callback) ->
    @model.get(ns).findByIdAndRemove(id, callback)

  update: (ns, data, callback) ->
    @model.get(ns).update({_id: data.id or data._id}, _.omit(data, ['_id']), callback)

  findById: (ns, id, callback) ->
    @model.get(ns).findById(id, callback)

  findAll: (ns, callback) ->
    @model.get(ns).find({}, callback)

module.exports = ProductGroupStore