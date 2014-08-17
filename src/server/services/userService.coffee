crypto = require('crypto')
userStore = inject('persistence/userStore')
inviteService = inject('services/inviteService')
emailService = inject('services/emailService')
mailer = inject('util/mailer')
templateService = inject('services/templateService')
linkService = inject('services/linkService')

module.exports = (passport) ->
  {
  approveRegistration: (data, callback) ->
    password = data.password
    confirmPassword = data.confirmPassword

    return callback({ password: '' }) if not password
    return callback({ confirmPassword: '' }) if not confirmPassword
    return callback({ generic: 'Пароли не совпадают' }) if password and confirmPassword and password isnt confirmPassword

    inviteService.find data.id, (err, invite) =>
      return console.log(err) if err
      return callback({ generic: 'Вы уже подтверждали регистрацию' }) if not err and not invite

      user = {
        firstName: invite.firstName
        email: invite.email
        password: data.password
      }
      @create user, (err) ->
        return console.log(err) if err
        inviteService.remove(invite, callback)

  register: (data, callback) ->
    return callback({ firstName: '' }) if not data.firstName
    return callback({ email: '' }) if not data.email

    @findByEmail data.email, (err, user) ->
      return console.log(err) if err
      return callback({ generic: 'Учетная запись уже существует' }) if user

      linkService.create data.email, (err, link) ->
        inviteData = {
          firstName: data.firstName
          email: data.email
          link: link.link
        }
        inviteService.create(inviteData, callback)

  authenticate: (data, loginHandler, callback) ->
    return loginHandler({ login: '' }) if not data.login
    return loginHandler({ password: '' }) if not data.password

    callback(passport.authenticate('local', loginHandler))

  forgotPassword: (email, callback) ->
    return callback({ generic: '' }) if not email

    @findByEmail email, (err, user) =>
      return callback({ generic: 'Учетной записи не найдено' }) if not user

      linkService.findByEmail email, (err, link) ->
        return console.log(err) if err
        return callback('Письмо уже было отправлено') if link

        linkService.create email, (err, link) ->
          return console.log(err) if err

          mail = emailService(mailer, templateService)
          mail.changePassword(link, callback)

  create: (data, callback) ->
    data.password = crypto.createHash('md5').update(data.password).digest('hex')
    userStore.create(data, callback)

  findById: (id, callback) ->
    userStore.findById(id, callback)

  findByCredentials: (login, password, callback) ->
    encryptedPass = crypto.createHash('md5').update(password).digest('hex')
    userStore.findByCredentials(login, encryptedPass, callback)

  findByEmail: (email, callback) ->
    userStore.findByEmail(email, callback)
  }
