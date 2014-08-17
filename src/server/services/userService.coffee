crypto = require('crypto')
userStore = inject('persistence/userStore')
inviteService = inject('services/inviteService')
generatorLinkService = inject('util/linkGenerator')
eventBus = inject('util/eventBus')

module.exports = (passport) ->
  {
  approveRegistration: (data, callback) ->
    password = data.password
    confirmPassword = data.confirmPassword

    if not password
      return callback({ password: '' })
    else if not confirmPassword
      return callback({ confirmPassword: '' })
    else if password and confirmPassword and password isnt confirmPassword
      return callback({ generic: 'Пароли не совпадают' })

    inviteService.find data.id, (err, invite) =>
      if err
        return console.log(err) # handle properly this case
      else if not err and not invite
        return callback({ generic: 'Вы уже подтверждали регистрацию' })
      else
        user = {
          firstName: invite.firstName
          email: invite.email
          password: data.password
        }
        @create user, (err) ->
          if err
            return console.log(err) # handle properly this case
          inviteService.remove(invite._id, callback)

  register: (data, callback) ->
    return callback({ firstName: '' }) if not data.firstName
    return callback({ email: '' }) if not data.email

    @findByEmail data.email, (err, user) ->
      return console.log(err) if err
      return callback({ generic: 'Учетная запись уже существует' }) if user

      generatorLinkService.generateLink (err, generatedLink) ->
        inviteData = {
          firstName: data.firstName
          email: data.email
          generatedLink: generatedLink
        }
        inviteService.create(inviteData, callback)

  authenticate: (data, loginHandler, callback) ->
    return loginHandler({ login: '' }) if not data.login
    return loginHandler({ password: '' }) if not data.password

    callback(passport.authenticate('local', loginHandler))

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
