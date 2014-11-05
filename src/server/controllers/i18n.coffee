class ResourceController

  constructor: (@i18n) ->

  register: (router) ->
    router.get '/i18n/messages/:batch', (req, res) =>
      res.send(@i18n.bundle(req.params.batch))

module.exports = ResourceController
