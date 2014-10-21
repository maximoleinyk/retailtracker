class ResourceController

  constructor: (@i18nService) ->

  register: (router) ->
    router.get '/i18n/messages/:batch', (req, res) =>
      res.send(@i18nService.bundle(req.params.batch))

module.exports = ResourceController
