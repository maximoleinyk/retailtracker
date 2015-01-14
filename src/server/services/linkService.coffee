linkStore = inject('persistence/linkStore')
generateRequestLink = inject('util/linkGenerator')

class LinkService

  constructor: (@linkStore) ->

  findByKey: (key, callback) ->
    @linkStore.findByKey(key, callback)

  removeByAccountId: (accountId, callback) ->
    @linkStore.removeByAccountId(accountId, callback)

  removeByKey: (link, callback) ->
    @linkStore.removeByKey(link, callback)

  create: (accountId, callback) ->
    generateRequestLink (err, generatedLink) =>
      return callback(err) if err
      data = {
        account: accountId,
        link: generatedLink
      }
      @linkStore.create(data, callback)

module.exports = LinkService
