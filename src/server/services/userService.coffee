crypto = require('crypto')
userStore = inject('persistence/userStore')
inviteService = inject('services/inviteService')
emailService = inject('services/emailService')
mailer = inject('util/mailer')
templateService = inject('services/templateService')
linkService = inject('services/linkService')

module.exports =
  {
  changeForgottenPassword: (data, callback) ->
    @changePassword data, (err, user) ->
      linkService.removeByKey data.link, (err) ->
        return callback(err) if err
        changePasswordData = {
          email: data.email
          firstName: user.firstName
          lastName: user.lastName
        }
        mail = emailService(mailer, templateService)
        mail.passwordChanged(changePasswordData, callback)

  changePassword: (data, callback) ->
    password = data.password
    confirmPassword = data.confirmPassword

    return callback({ password: '' }) if not password
    return callback({ confirmPassword: '' }) if not confirmPassword
    return callback({ generic: 'Пароли не совпадают' }) if password and confirmPassword and password isnt confirmPassword

    @findByEmail data.email, (err, user) =>
      return callback(err) if err
      return callback({ generic: 'Такой учетной записи не сущетвует' }) if not user

      user.password = @encryptPassword(password)
      userStore.update user, (err) ->
        return callback(err) if err
        callback(null, user)

  approveRegistration: (data, callback) ->
    password = data.password
    confirmPassword = data.confirmPassword

    return callback({ password: '' }) if not password
    return callback({ confirmPassword: '' }) if not confirmPassword
    return callback({ generic: 'Пароли не совпадают' }) if password and confirmPassword and password isnt confirmPassword

    inviteService.find data.link, (err, invite) =>
      return callback(err) if err
      return callback({ generic: 'Вы уже подтверждали регистрацию' }) if not err and not invite

      user = {
        firstName: invite.firstName
        email: invite.email
        password: data.password
      }
      @create user, (err) ->
        return callback(err) if err
        inviteService.remove(invite, callback)

  register: (data, callback) ->
    return callback({ firstName: '' }) if not data.firstName
    return callback({ email: '' }) if not data.email

    @findByEmail data.email, (err, user) ->
      return callback(err) if err
      return callback({ generic: 'Учетная запись уже существует' }) if user

      linkService.create data.email, (err, link) ->
        inviteService.create(data.firstName, data.email, link.link, callback)

  forgotPassword: (email, callback) ->
    return callback({ generic: '' }) if not email

    @findByEmail email, (err, user) =>
      return callback({ generic: 'Учетной записи не найдено' }) if not user

      linkService.findByEmail email, (err, link) ->
        return callback(err) if err
        return callback({ generic: 'Письмо уже было отправлено' }) if link

        linkService.create email, (err, link) ->
          return callback(err) if err

          mail = emailService(mailer, templateService)
          mail.changePassword(link, callback)

  encryptPassword: (password) ->
    crypto.createHash('md5').update(password).digest('hex')

  create: (data, callback) ->
    data.password = @encryptPassword(data.password)
    userStore.create(data, callback)

  update: (data, callback) ->
    userStore.update(data, callback)

  findById: (id, callback) ->
    userStore.findById(id, callback)

  findByCredentials: (login, password, callback) ->
    encryptedPass = @encryptPassword(password)
    userStore.findByCredentials(login, encryptedPass, callback)

  findByEmail: (email, callback) ->
    userStore.findByEmail(email, callback)
  }
