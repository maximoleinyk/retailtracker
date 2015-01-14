Link = inject('persistence/model/link')

class LinkStore

  create: (data, callback) ->
    link = new Link(data)
    link.save(callback)

  removeByAccountId: (accountId, callback) ->
    Link.remove({ account: accountId }, callback)

  removeByKey: (link, callback) ->
    Link.findOneAndRemove({ link: link }, callback)

  findByKey: (key, callback) ->
    Link.findOne({ link: key }, callback)

  findByEmail: (email, callback) ->
    Link.findOne({ email: email }, callback)

module.exports = LinkStore
