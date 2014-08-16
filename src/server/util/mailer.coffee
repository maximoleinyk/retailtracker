path = require('path')
nodeMailer = require('nodemailer')

module.exports =  ->
  transporter = nodeMailer.createTransport
    host: config.mailer.host,
    port: config.mailer.port
    auth:
      user: config.mailer.user
      pass: config.mailer.pass

  send: (to, subject, template, callback) ->
    template (err, html) ->
      return callback(err) if err
      transporter.sendMail {
        from: config.mailer.user
        to: to
        subject: subject
        html: html
      }, callback




