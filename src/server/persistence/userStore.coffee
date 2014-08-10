User = inject('persistence/model/user')
crypto = require('crypto')

module.exports =

  create: (data, callback) ->
    user = new User(data)
    user.save(callback)

  findById: (id, callback) ->
    User.findById id, (err, doc) ->
      callback(err, doc?.toObject())

  findByCredentials: (email, password, callback) ->
    encryptedPass = crypto.createHash('md5').update(password).digest('hex')
    criteria =
      email: email
      password: encryptedPass
    User.findOne criteria, (err, doc) ->
      callback(err, doc?.toObject())
