Invite = inject('persistence/model/invite')

module.exports = {

  create: (data, callback) ->
    invite = new Invite(data)
    invite.save (err, doc) ->
      return callback(err) if err
      Invite.findById(doc._id, callback).populate('user')

  findByUserAndCompany: (ns, userId, companyId, callback) ->
    criteria = {
      user: userId
      company: companyId
      ns: ns
    }
    Invite.findOne(criteria, callback)

  findByLink: (link, callback) ->
    Invite.findOne({ link: link }, callback).populate('user')

  findByEmail: (email, callback) ->
    Invite.findOne({ email: email }, callback)

  remove: (id, callback) ->
    Invite.findByIdAndRemove(id, callback)

}
