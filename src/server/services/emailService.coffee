module.exports = (mailer, compile) ->
  companyInvite: (data, callback) ->
    subject = 'Приглашение в компанию'
    template = compile('companyInvite', data)
    mailer.send(data.user.email, subject, template, callback)

  successfulRegistration: (data, callback) ->
    subject = 'Регистрация завершена'
    template = compile('successfulRegistration', data)
    mailer.send(data.user.email, subject, template, callback)

  registrationInvite: (data, callback) ->
    subject = 'Регистрация'
    template = compile('registrationInvite', data)
    mailer.send(data.user.email, subject, template, callback)

  changePassword: (data, callback) ->
    subject = 'Забыли пароль?'
    template = compile('forgotPassword', data)
    mailer.send(data.email, subject, template, callback)

  passwordChanged: (data, callback) ->
    subject = 'Пароль изменен'
    template = compile('passwordChanged', data)
    mailer.send(data.email, subject, template, callback)

