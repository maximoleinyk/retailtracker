Promise = inject('util/promise')
generateRequestLink = inject('util/linkGenerator')

class InviteService

  constructor: (@inviteStore, @linkService) ->

  findByLink: (link, callback) ->
    @inviteStore.findByLink(link, callback)

  findByUserAndCompany: (userId, companyId, callback) ->
    @inviteStore.findByUserAndCompany(userId, companyId, callback)

  generateInviteForAccountOwner: (email, firstName, callback) ->
    removeAllExistingInvites = new Promise (resolve, reject) =>
      @inviteStore.removeByEmailAndAccount email, null, (err) ->
        if err then reject(err) else resolve()

    removeAllExistingInvites
    .then =>
      new Promise (resolve, reject) =>
        generateRequestLink (err, link) ->
          if err then reject(err) else resolve(link)

    .then (link) =>
      data = {
        firstName: firstName
        email: email
        link: link
      }
      new Promise (resolve, reject) =>
        @inviteStore.create data, (err, invite) ->
          if err then reject(err) else resolve(invite)

    .then (result) ->
      callback(null, result)

    .catch(callback)

  generateInviteForEmployee: (user, company, namespace, callback) ->
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
        @inviteStore.create data, (err, invite) ->
          if err then reject(err) else resolve(invite)

    .then (result) ->
      callback(null, result)

    .then null, (err) ->
      callback({ generic: err })

  remove: (inviteId, callback) ->
    remove = new Promise (resolve, reject) =>
      @inviteStore.remove inviteId, (err, result) ->
        if err then reject(err) else resolve(result)

    remove
    .then (result) ->
      callback(null, result)

    .catch(callback)

module.exports = InviteService
