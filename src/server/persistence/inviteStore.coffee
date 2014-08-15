Invite = inject('persistence/model/invite')

module.exports =

  create: (data, callback) ->
    invite = new Invite(data)
    invite.save(callback)

  findByEmail: (email, callback) ->
    Invite.findOne { email: email }, (err, doc) ->
      callback(err, doc?.toObject())