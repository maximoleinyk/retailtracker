Invite = inject('persistence/model/invite')

class InviteStore

  create: (data, callback) ->
    invite = new Invite(data)
    invite.save (err, doc) ->
      return callback(err) if err
      Invite.findById(doc._id, callback).populate('user')

  removeByEmailAndAccount: (email, account, callback) ->
    Invite.remove({ email: email, account: account }, callback)

  findByEmailAndCompany: (email, companyId, callback) ->
    criteria = {
      email: email
      company: companyId
    }
    Invite.findOne(criteria, callback)

  findByLink: (link, callback) ->
    Invite.findOne({ link: link }, callback).populate('user')

  findByEmail: (email, callback) ->
    Invite.findOne({ email: email }, callback)

  remove: (id, callback) ->
    Invite.findByIdAndRemove(id, callback)

module.exports = InviteStore
