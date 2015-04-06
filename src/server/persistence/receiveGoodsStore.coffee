AbstractStore = inject('persistence/abstractStore')

class ReceiveGoodsStore extends AbstractStore

  search: (ns, query = '', limit = 5, callback) ->
    @model.get(ns).find({
      status: 'ENTERED'
      name: new RegExp(query, 'i')
    }).limit(limit).exec(callback)

  findById: (ns, id, callback) ->
    @model.get(ns).findOne({status: {'$ne': 'DELETED'}, _id: id}, @callback(callback)).populate('assignee warehouse currency items.nomenclature')

  findAll: (ns, callback) ->
    @model.get(ns).find({status: {'$ne': 'DELETED'}}, @callback(callback)).populate('assignee warehouse currency')

module.exports = ReceiveGoodsStore
