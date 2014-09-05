path = require('path')
fs = require('fs')

module.exports = {
  bundle: (batch) ->
    filePath = path.resolve(config.resourcesDir + '/i18n/' + batch + '.properties')
    result = {}
    data = fs.readFileSync(filePath, 'utf8')
    lines = data.toString('utf8').split('\n')

    for line in lines
      do ->
        line = line?.trim()
        if line and line.split('=')[0]?.trim()
          result[line.split('=')[0].trim()] = line.split('=')[1]

    result
}