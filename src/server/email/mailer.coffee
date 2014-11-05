path = require('path')
nodeMailer = require('nodemailer')

transporter = nodeMailer.createTransport
  host: config.mailer.host,
  port: config.mailer.port
  auth:
    user: config.mailer.user
    pass: config.mailer.pass

module.exports = {

  send: (to, subject, template, callback) ->
    template (err, html) ->
      return callback(err) if err

      data = {
        from: config.mailer.user
        to: to
        subject: subject
        html: html
      }
      transporter.sendMail(data, callback)

}



