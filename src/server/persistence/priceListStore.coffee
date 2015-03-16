AbstractStore = inject('persistence/abstractStore')

class PriceListStore extends AbstractStore

  findById: (ns, id, callback) ->
    @model.get(ns).findOne({state: {'$ne': 'DELETED'}, _id: id}, @callback(callback)).populate('template')

  findAll: (ns, callback) ->
    @model.get(ns).find({state: {'$ne': 'DELETED'}}, @callback(callback)).populate('template')

module.exports = PriceListStore
