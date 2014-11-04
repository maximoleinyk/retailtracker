emailTemplates = require('email-templates')

module.exports = (name, data) ->
  (callback) ->
    emailTemplates config.mailer.templatesDir, (err, compile) ->
      if err then callback(err) else compile(name, data, callback)