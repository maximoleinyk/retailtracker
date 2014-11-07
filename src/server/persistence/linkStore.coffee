Link = inject('persistence/model/link')

module.exports = {

  create: (data, callback) ->
    new Link(data).save(callback)

  removeByEmail: (email, callback) ->
    Link.remove({ email: email }, callback)

  removeByKey: (link, callback) ->
    Link.findOneAndRemove({ link: link }, callback)

  findByKey: (key, callback) ->
    Link.findOne({ link: key }, callback)

  findByEmail: (email, callback) ->
    Link.findOne({ email: email }, callback)

}
