Uom = inject('persistence/model/uom')
_ = require('underscore')

class UomStore

  create: (data, callback) ->
    uom = new Uom(data)
    uom.save (err, doc) ->
      callback(err, doc?.toObject())

  delete: (id, callback) ->
    Uom.findByIdAndRemove(id, callback)

  update: (data, callback) ->
    Uom.findOneAndUpdate {_id: data.id}, _.omit(data, ['id']), (err, doc) ->
      callback(err, doc?.toObject())

  findAll: (callback) ->
    Uom.find({}, callback)

module.exports = UomStore