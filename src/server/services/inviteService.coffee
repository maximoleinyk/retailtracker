inviteStore = inject('persistence/inviteStore')
linkService = inject('services/linkService')
Promise = inject('util/promise')
generateRequestLink = inject('util/linkGenerator')

module.exports = {

  findByLink: (link, callback) ->
    inviteStore.findByLink(link, callback)

  findByUserAndCompany: (userId, companyId, callback) ->
    inviteStore.findByUserAndCompany(userId, companyId, callback)

  createAccountInvite: (user, callback) ->
    return callback({ generic: 'User object must be provided' }) if not user

    generateLink = new Promise (resolve, reject) =>
      generateRequestLink (err, link) ->
        if err then reject(err) else resolve(link)

    generateLink
    .then (link) =>
      new Promise (resolve, reject) =>
        data = {
          user: user._id
          link: link
        }
        inviteStore.create data, (err, invite) ->
          if err then reject(err) else resolve(invite)

    .then (result) ->
      callback(null, result)

    .then null, (err) ->
      callback({ generic: err })

  createCompanyInvite: (user, company, namespace, callback) ->
    generateLink = new Promise (resolve, reject) =>
      generateRequestLink (err, link) ->
        if err then reject(err) else resolve(link)

    generateLink
    .then (link) =>
      new Promise (resolve, reject) =>
        data = {
          user: user
          link: link
          company: company
          ns: namespace
        }
        inviteStore.create data, (err, invite) ->
          if err then reject(err) else resolve(invite)

    .then (result) ->
      callback(null, result)

    .then null, (err) ->
      callback({ generic: err })

  remove: (invite, callback) ->
    remove = new Promise (resolve, reject) =>
      inviteStore.remove invite._id, (err, result) ->
        if err then reject(err) else resolve(result)

    remove
    .then (result) ->
      callback(null, result)

    .then(null, callback)
}
