crypto = require('crypto')

module.exports = {
  generateLink: (callback) ->
    crypto.randomBytes 48, (err, buf) ->
      return callback(err) if err
      callback(null, buf.toString('base64').replace(/\//g, '_').replace(/\+/g, '-'))
}
