Mailer = inject('util/mailer')

module.exports = (mailer, templateService) ->

  approveRegistration: (user, callback) ->
    subject = 'Подтверждение регистрации'
    template = templateService.template('approveRegistration', { user: user })
    mailer.send user.email, subject, template, callback
