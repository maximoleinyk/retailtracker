HttpStatus = require('http-status-codes')
path = require('path')
fs = require('fs')
authFilter = inject('util/authFilter')
userService = inject('services/userService')

module.exports = (router) ->

  router.get '/i18n/messages/:batch', (req, res) ->
    batch = req.params.batch
    filePath = path.resolve(config.resourcesDir + '/i18n/' + batch + '.properties')
    result = {}

    fs.readFile filePath, 'utf8', (err, data) ->
      return res.send(err) if err

      lines = data.toString('utf8').split('\n')
      for line in lines
        do ->
          line = line?.trim()
          if line and line.split('=')[0]?.trim()
            result[line.split('=')[0].trim()] = line.split('=')[1]

      res.send(result)

