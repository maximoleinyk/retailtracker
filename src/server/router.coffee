
module.exports = (app, config) ->

  app.get "/*", (req, res) ->
    res.sendfile config.indexFile, { url: req.url }
