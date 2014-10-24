inviteStore = inject('persistence/inviteStore')
emailService = inject('services/emailService')
mailer = inject('util/mailer')
templateService = inject('services/templateService')
linkService = inject('services/linkService')

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

  createCompanyInvite: (email, link, companyId, callback) ->
    data = {
      email: email
      link: link
      companyId: companyId
    }
    inviteStore.create data, (err, invite) ->
      return callback(err) if err
      mail = emailService(mailer, templateService)
      mail.companyInvite(invite, callback)

  remove: (data, callback) ->
    inviteStore.remove data._id, (err) ->
      return callback(err) if err
      linkService.removeByKey data.link, (err) ->
        mail = emailService(mailer, templateService)
        mail.successfulRegistration(data, callback)
}
