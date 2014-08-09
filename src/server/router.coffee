module.exports = (passport, router, config) ->

  # always return single HTML page on leading /ui* part
  router.get "/ui*", (req, res) ->
    res.sendFile config.indexFile

  # redirect from root directory to UI
  router.get '/', (req, res) ->
    res.redirect '/ui'

  # check authentication for every single HTTP request
  router.all /\/(?!static)\*/, (req, res, next) ->
    if req.isAuthenticated()
      next()
    else
      res.status(401).send('Unauthorized')
