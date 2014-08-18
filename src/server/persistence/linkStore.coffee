Link = inject('persistence/model/link')

module.exports = {

  create: (data, callback) ->
    link = new Link(data)
    link.save(callback)

  removeByKey: (link, callback) ->
    Link.findOneAndRemove({ link: link }, callback)

  findByKey: (key, callback) ->
    Link.findOne { link: key }, (err, doc) ->
      callback(err, doc?.toObject())

  findByEmail: (email, callback) ->
    Link.findOne { email: email }, (err, doc) ->
      callback(err, doc?.toObject())
}
