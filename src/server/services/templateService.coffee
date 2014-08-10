emailTemplates = require('email-templates')

module.exports = (config) ->
  templates = config.mailer.templatesDir
  {
  template: (name, data) ->
    (callback) ->
      emailTemplates templates, (err, compile) ->
        if err then callback(err) else compile(name, data, callback)
  }
