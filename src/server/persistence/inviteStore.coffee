Invite = inject('persistence/model/invite')

module.exports = {

  create: (data, callback) ->
    invite = new Invite(data)
    invite.save (err, doc) ->
      return callback(err) if err
      Invite.findOne(doc._id, callback).populate('user')

  findByLink: (link, callback) ->
    Invite.findOne({ link: link }, callback).populate('user')

  findByEmail: (email, callback) ->
    Invite.findOne { email: email }, (err, doc) ->
      callback(err, doc?.toObject())

  remove: (id, callback) ->
    Invite.findByIdAndRemove(id, callback)

}
