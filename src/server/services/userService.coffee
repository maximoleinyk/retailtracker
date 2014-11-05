crypto = require('crypto')
userStore = inject('persistence/userStore')
inviteService = inject('services/inviteService')
emailService = inject('services/emailService')
mailer = inject('util/mailer')
templateService = inject('services/templateService')
linkService = inject('services/linkService')

class UserService

  constructor: (@userStore) ->

  create: (data, callback) ->
    @userStore.create(data, callback)

  update: (data, callback) ->
    @userStore.update(data, callback)

  findById: (id, callback) ->
    @userStore.findById(id, callback)

  findByEmail: (email, callback) ->
    @userStore.findByEmail(email, callback)

  suspendUser: (user, callback) ->


module.exports = UserService