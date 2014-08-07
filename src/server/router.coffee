module.exports = (passport, router, config) ->

  # always return single HTML page on leading /ui* part
  router.get "/ui*", (req, res) ->
    res.sendFile config.indexFile

  router.post '/security/login', (req, res, next) ->
    authenticate = (err, user) ->
      console.log('LOGIN')
      console.log(user)
      return next(err) if err
      return res.send(401) if not user
      req.logIn user, (err) ->
        return next(err) if err
        res.send(204)
    passport.authenticate('local', authenticate)(req, res, next)

  # check authentication for every single HTTP request
  router.all '/*', (req, res, next) ->
    if req.isAuthenticated()
      next()
    else
      res.send(401, 'Unauthorized')