Model = inject('persistence/model/uom')
_ = require('underscore')

class UomStore

  constructor: ->
    @model = new Model

  create: (ns, data, callback) ->
    Uom = @model.get(ns)

    uom = new Uom(data)
    uom.save(callback)

  delete: (ns, id, callback) ->
    @model.get(ns).findByIdAndRemove(id, callback)

  update: (ns, data, callback) ->
    @model.get(ns).update({_id: data._id}, _.omit(data, ['_id']), callback)

  findAll: (ns, callback) ->
    @model.get(ns).find({}, callback)

module.exports = UomStore