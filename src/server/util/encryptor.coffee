module.exports = Encryptor

crypto = require('crypto')

class Encryptor

  md5: (password) ->
    crypto.createHash('md5').update(password).digest('hex')