eventBus = inject('util/eventBus')
emailService = inject('services/emailService')
mailer = inject('util/mailer')
templateService = inject('services/templateService')

module.exports = (config) ->

  mail = emailService(mailer(config), templateService(config))

  eventBus.on 'mail:send:invite', (inviteData, callback) ->
    mail.registrationInvite(inviteData, callback)