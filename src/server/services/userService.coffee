userStore = inject('persistence/userStore')
inviteStore = inject('persistence/inviteStore')
generatorLinkService = inject('util/linkGenerator')
eventBus = inject('util/eventBus')

module.exports =

  register: (data, callback) ->

    generatorLinkService.generateLink (err, generatedLink) ->
      inviteData = {
        firstName: data.firstName
        email: data.email
        generatedLink: generatedLink
      }
      inviteStore.create inviteData, (err) ->
        return callback('На ваш почтовый адресс уже было выслано письмо с подтверждением регистрации.') if err
        eventBus.emit('mail:send:invite', inviteData, callback)

  create: (data, callback) ->
    userStore.create(data, callback)

  findById: (id, callback) ->
    userStore.findById(id, callback)

  findByCredentials: (login, password, callback) ->
    userStore.findByCredentials(login, password, callback)
