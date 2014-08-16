crypto = require('crypto')
userStore = inject('persistence/userStore')
inviteService = inject('services/inviteService')
generatorLinkService = inject('util/linkGenerator')
eventBus = inject('util/eventBus')

module.exports =

  approveRegistration: (data, callback) ->
    inviteService.find data.id, (err, invite) =>
      return callback(err) if err
      return callback('Not found') if not invite

      user = {
        firstName: invite.firstName
        email: invite.email
        password: data.password
      }
      @create user, (err) ->
        return callback(err) if err
        inviteService.remove(invite._id, callback)

  register: (data, callback) ->
    generatorLinkService.generateLink (err, generatedLink) ->
      inviteData = {
        firstName: data.firstName
        email: data.email
        generatedLink: generatedLink
      }
      inviteService.create(inviteData, callback)

  create: (data, callback) ->
    data.password = crypto.createHash('md5').update(data.password).digest('hex')
    userStore.create(data, callback)

  findById: (id, callback) ->
    userStore.findById(id, callback)

  findByCredentials: (login, password, callback) ->
    encryptedPass = crypto.createHash('md5').update(password).digest('hex')
    userStore.findByCredentials(login, encryptedPass, callback)
