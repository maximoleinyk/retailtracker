inviteStore = inject('persistence/inviteStore')
emailService = inject('services/emailService')
mailer = inject('util/mailer')
templateService = inject('services/templateService')
linkService = inject('services/linkService')

module.exports = {

  find: (key, callback) ->
    inviteStore.findByKey(key, callback)

  create: (data, callback) ->
    inviteStore.create data, (err, invite) ->
      return callback('На ваш почтовый адресс уже было выслано письмо.') if err

      mail = emailService(mailer, templateService)
      mail.registrationInvite(invite, callback)

  remove: (data, callback) ->
    inviteStore.remove data._id, (err) ->
      return callback(err) if err

      linkService.removeByKey data.link, (err) ->
        mail = emailService(mailer, templateService)
        mail.successfulRegistration(data, callback)
}
