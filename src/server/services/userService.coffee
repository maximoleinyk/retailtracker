userStore = inject('persistence/userStore')

module.exports =

  register: (data, callback) ->
    inviteStore.createInvite(data)
    # создать инвайт
    # genegate permanent link
    # send email with link
    # start cron job если не зайдет в течении суток удалить из базы инвайт

  create: (data, callback) ->
    userStore.create(data, callback)

  findById: (id, callback) ->
    userStore.findById(id, callback)

  findByCredentials: (login, password, callback) ->
    userStore.findByCredentials(login, password, callback)
