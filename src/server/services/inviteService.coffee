inviteStore = inject('persistence/inviteStore')
emailService = inject('services/emailService')
mailer = inject('util/mailer')
templateService = inject('services/templateService')
linkService = inject('services/linkService')
Promise = inject('util/promise')

module.exports = {

  find: (key, callback) ->
    inviteStore.findByKey(key, callback)

  create: (firstName, email, link, callback) ->
    data = {
      firstName: firstName
      email: email
      link: link
    }
    inviteStore.create data, (err, invite) ->
      return callback(err) if err
      mail = emailService(mailer, templateService)
      mail.registrationInvite(invite, callback)

  createAccountInvite: (user, callback) ->
    return callback({ generic: 'User object must be provided' }) if not user

    createLink = new Promise (resolve, reject) =>
      linkService.create user.email, (err, link) ->
        if err then reject(err) else resolve(link)

    createLink
    # create link
    .then (link) =>
      new Promise (resolve, reject) =>
        data = {
          firstName: user.firstName
          email: user.email
          link: link.link
        }
        inviteStore.create data, (err, invite) ->
          if err then reject(err) else resolve(invite)

    # send email
    .then (invite) =>
      mail = emailService(mailer, templateService)
      new Promise (resolve, reject) =>
        mail.registrationInvite invite, (err, result) ->
          if err then reject(err) else resolve(result)

    .then (result) ->
      callback(null, result)

    .then null, (err) ->
      callback({ generic: err })

  createCompanyInvite: (firstName, email, link, companyId, callback) ->
    data = {
      firstName: firstName
      email: email
      link: link
      companyId: companyId
    }
    inviteStore.create data, (err, invite) ->
      return callback(err) if err
      mail = emailService(mailer, templateService)
      mail.companyInvite(invite, callback)

  findByLink: (link, callback) ->
    inviteStore.findByLink(link, callback)

  remove: (data, callback) ->
    inviteStore.remove data._id, (err) ->
      return callback(err) if err
      linkService.removeByKey data.link, (err) ->
        mail = emailService(mailer, templateService)
        mail.successfulRegistration(data, callback)
}
