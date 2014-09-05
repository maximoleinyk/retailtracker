i18nService = inject('services/i18nService')

module.exports = (router) ->
  router.get '/i18n/messages/:batch', (req, res) ->
    req.session.bundleName = req.params.batch
    res.send(i18nService.bundle(req.params.batch))

