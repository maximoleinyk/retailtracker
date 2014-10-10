Uom = inject('persistence/model/uom')

class UomStore

  create: (data, callback) ->
    uom = new Uom(data)
    uom.save (err, doc) ->
      callback(err, doc?.toObject())

  findAll: (callback) ->
    Uom.find({}, callback)

module.exports = UomStore