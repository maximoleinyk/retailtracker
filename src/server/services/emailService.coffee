module.exports = (mailer, templateService) ->
  successfulRegistration: (data, callback) ->
    subject = 'Рагистрация завершена'
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
