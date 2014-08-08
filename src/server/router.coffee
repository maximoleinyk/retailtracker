module.exports = (passport, router, config) ->

  # always return single HTML page on leading /ui* part
  router.get "/ui*", (req, res) ->
    res.sendFile config.indexFile

  # check authentication for every single HTTP request
  router.all '/*', (req, res, next) ->
    if req.isAuthenticated()
      next()
    else
      res.send(401, 'Unauthorized')
