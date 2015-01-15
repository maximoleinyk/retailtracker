path = require('path')
util = require('util')
aws = require('aws-sdk')

module.exports = {

  send: (to, subject, template, callback) ->

    template (err, html) ->
      return callback(err) if err
      util.log(html)
      callback()

#      aws.config.loadFromPath('./aws.json');
#      ses = new aws.SES({ apiVersion: '2010-12-01'})
#
#      config =
#        Source: 'support@retalregister.net',
#        Destination:
#          ToAddresses: to
#        Message:
#          Subject:
#            Data: subject
#          Body:
#            Html:
#              Data: html
#
#      handler = (err) ->
#        return callback(err) if err
#
#      ses.sendEmail(config, handler)

}
