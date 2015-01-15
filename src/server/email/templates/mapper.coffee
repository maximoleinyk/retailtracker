module.exports = (mailer, compile) ->
  companyInvite: (invite, callback) ->
    subject = 'Приглашение в компанию'
    template = compile('companyInvite', invite.toJSON())
    mailer.send(invite.email, subject, template, callback)

  successfulRegistration: (account, callback) ->
    subject = 'Регистрация завершена'
    template = compile('successfulRegistration', account.toJSON())
    mailer.send(account.login, subject, template, callback)

  registrationInvite: (invite, callback) ->
    subject = 'Регистрация'
    template = compile('registrationInvite', invite.toJSON())
    mailer.send(invite.email, subject, template, callback)

  changePassword: (accountAndLink, callback) ->
    subject = 'Забыли пароль?'
    template = compile('forgotPassword', accountAndLink.link.toJSON())
    mailer.send(accountAndLink.account.login, subject, template, callback)

  passwordChanged: (link, callback) ->
    subject = 'Пароль изменен'
    template = compile('passwordChanged', link.toJSON())
    mailer.send(link.email, subject, template, callback)

