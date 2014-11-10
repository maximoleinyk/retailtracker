inviteStore = inject('persistence/inviteStore')
emailTemplates = inject('email/templates/mapper')
mailer = inject('email/mailer')
templateCompiler = inject('email/templateCompiler')
linkService = inject('services/linkService')
Promise = inject('util/promise')
generatorLinkService = inject('util/linkGenerator')

module.exports = {

  findByLink: (link, callback) ->
    inviteStore.findByLink(link, callback)

  create: (firstName, email, link, callback) ->
    data = {
      firstName: firstName
      email: email
      link: link
    }
    inviteStore.create data, (err, invite) ->
      return callback(err) if err
      mail = emailTemplates(mailer, templateCompiler)
      mail.registrationInvite(invite, callback)

  createAccountInvite: (user, callback) ->
    return callback({ generic: 'User object must be provided' }) if not user

    generateLink = new Promise (resolve, reject) =>
      generatorLinkService.generateLink (err, link) ->
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

    .then (invite) =>
      mail = emailTemplates(mailer, templateCompiler)
      new Promise (resolve, reject) =>
        mail.registrationInvite invite, (err, result) ->
          if err then reject(err) else resolve(result)

    .then (result) ->
      callback(null, result)

    .then null, (err) ->
      callback({ generic: err })

  createCompanyInvite: (user, company, namespace, callback) ->
    generateLink = new Promise (resolve, reject) =>
      generatorLinkService.generateLink (err, link) ->
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

    .then (invite) =>
      new Promise (resolve, reject) =>
        mail = emailTemplates(mailer, templateCompiler)
        mail.companyInvite invite, (err, result) ->
          if err then reject(err) else resolve(result)

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
      new Promise (resolve, reject) =>
        mail = emailTemplates(mailer, templateCompiler)
        mail.successfulRegistration invite, (err, result) ->
          if err then reject(err) else resolve(result)

    .then (result) ->
      callback(null, result)

    .then(null, callback)
}
