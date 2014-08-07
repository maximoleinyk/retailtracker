user = {
  id: 1,
  login: 'simple@email.com',
  password: 'somehash'
}

module.exports =

  findById: (id, callback) ->
    return callback(null, user);