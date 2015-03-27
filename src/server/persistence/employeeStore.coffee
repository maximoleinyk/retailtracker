AbstractStore = inject('persistence/abstractStore')

class EmployeeStore extends AbstractStore

  searchField: 'email'

  findByEmail: (ns, email, callback) ->
    @model.get(ns).findOne({ email: email }, callback)

  findLikeByEmail: (ns, email, limit, callback) ->
    @model.get(ns).find({ email: new RegExp(email, 'i')}, callback).limit(limit)

module.exports = EmployeeStore
