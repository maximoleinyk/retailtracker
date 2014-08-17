linkStore = inject('persistence/linkStore')
generatorLinkService = inject('util/linkGenerator')

module.exports = {

  findByEmail: (email, callback) ->
    linkStore.findByEmail(email, callback)

  removeByKey: (link, callback) ->
    linkStore.removeByKey(link, callback)

  create: (email, callback) ->
    generatorLinkService.generateLink (err, generatedLink) ->
      return console.log(err) if err

      data = {
        email: email,
        link: generatedLink
      }
      linkStore.create(data, callback)
}
