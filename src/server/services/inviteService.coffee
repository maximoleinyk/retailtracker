inviteStore = inject('persistence/inviteStore')
emailService = inject('services/emailService')
mailer = inject('util/mailer')
templateService = inject('services/templateService')

module.exports = {

  find: (key, callback) ->
    inviteStore.findByKey(key, callback)

  create: (data, callback) ->
    inviteStore.create data, (err, invite) ->
      return callback('На ваш почтовый адресс уже было выслано письмо с подтверждением регистрации.') if err

      mail = emailService(mailer, templateService)
      mail.registrationInvite(invite, callback)

  remove: (id, callback) ->
    inviteStore.remove(id, callback)

}
