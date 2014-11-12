Uom = inject('persistence/model/uom')
_ = require('underscore')

class UomStore

  create: (data, callback) ->
    uom = new Uom(data)
    uom.save(callback)

  delete: (id, callback) ->
    Uom.findByIdAndRemove(id, callback)

  update: (data, callback) ->
    Uom.update({_id: data._id}, _.omit(data, ['_id']), callback)

  findAll: (callback) ->
    Uom.find({}, callback)

module.exports = UomStore