module.exports = (mailer, compile) ->
  companyInvite: (invite, callback) ->
    subject = 'Приглашение в компанию'
    template = compile('companyInvite', invite)
    mailer.send(invite.user.email, subject, template, callback)

  successfulRegistration: (invite, callback) ->
    subject = 'Регистрация завершена'
    template = compile('successfulRegistration', invite)
    mailer.send(invite.user.email, subject, template, callback)

  registrationInvite: (invite, callback) ->
    subject = 'Регистрация'
    template = compile('registrationInvite', invite)
    mailer.send(invite.user.email, subject, template, callback)

  changePassword: (link, callback) ->
    subject = 'Забыли пароль?'
    template = compile('forgotPassword', link)
    mailer.send(link.email, subject, template, callback)

  passwordChanged: (link, callback) ->
    subject = 'Пароль изменен'
    template = compile('passwordChanged', link)
    mailer.send(link.email, subject, template, callback)

