module.exports = (mailer, templateService) ->
  successfulRegistration: (data, callback) ->
    subject = 'Регистрация завершена'
    template = templateService.template('successfulRegistration', data)
    mailer.send(data.email, subject, template, callback)

  registrationInvite: (data, callback) ->
    subject = 'Регистрация'
    template = templateService.template('registrationInvite', data)
    mailer.send(data.email, subject, template, callback)

  changePassword: (data, callback) ->
    subject = 'Забыли пароль?'
    template = templateService.template('forgotPassword', data)
    mailer.send(data.email, subject, template, callback)

  passwordChanged: (data, callback) ->
    subject = 'Пароль изменен'
    template = templateService.template('passwordChanged', data)
    mailer.send(data.email, subject, template, callback)

