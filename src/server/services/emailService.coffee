module.exports = (mailer, templateService) ->
  approveRegistration: (user, callback) ->
    subject = 'Подтверждение регистрации'
    template = templateService.template('approveRegistration', user)
    mailer.send(user.email, subject, template, callback)

  registrationInvite: (inviteData, callback) ->
    subject = 'Подтверждение регистрации'
    template = templateService.template('registrationInvite', inviteData)
    mailer.send(inviteData.email, subject, template, callback)