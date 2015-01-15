Model = inject('persistence/model/role')
_ = require('underscore')

class RoleStore

  constructor: ->
    @model = new Model

  findAll: (ns, callback) ->
    @model.get(ns).find({}).where('name').ne('BOSS').exec(callback)

  findByName: (ns, name, callback) ->
    @model.get(ns).findOne({name: name}, callback)

  create: (ns, data, callback) ->
    Role = @model.get(ns)

    role = new Role(data)
    role.save(callback)

  findById: (ns, id, callback) ->
    @model.get(ns).findById(id, callback)

module.exports = RoleStore
