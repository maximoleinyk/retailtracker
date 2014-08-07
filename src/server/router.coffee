module.exports = (app, config) ->
  # always return single HTML page on leading /ui* part
  app.get "/ui*", (req, res) ->
    res.sendfile config.indexFile

  # check authentication for every single HTTP request
  app.all '/*', (req, res, next) ->
    if req.isAuthenticated()
      next()
    else
      res.send(401, 'Unauthorized')

