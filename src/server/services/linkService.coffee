linkStore = inject('persistence/linkStore')
generateRequestLink = inject('util/linkGenerator')

module.exports = {

  findByKey: (key, callback) ->
    linkStore.findByKey(key, callback)

  findByEmail: (email, callback) ->
    linkStore.findByEmail(email, callback)

  removeByEmail: (email, callback) ->
    linkStore.removeByEmail(email, callback)

  removeByKey: (link, callback) ->
    linkStore.removeByKey(link, callback)

  create: (email, callback) ->
    generateRequestLink (err, generatedLink) ->
      return callback(err) if err
      data = {
        email: email,
        link: generatedLink
      }
      linkStore.create(data, callback)
}
