userStore = inject('persistence/userStore')

module.exports = (config) ->

  register: (data, callback) ->

    inviteStore.findInvite data.email, (err, foundInvite) ->
      return callback('Please check your mail') if foundInvite

      generatedLink = generatorLinkService.generateLink()
      inviteData = {
        name: data.firstName
        email: data.email
        generatedLink: generatedLink
      }

      inviteStore.createInvite inviteData, (err) ->
        if err
          return # handle properly this case

        task = scheduler.scheduleTask 'every 24 hours', ->
          inviteStore.deleteInvite email, (err) ->
            if err
              return # handle properly this case

        templates = emailService(mailer(config), templateService(config))
        templates.sendInvite data.email, (err, result) ->
          if err
            return #handle properly this case

  create: (data, callback) ->
    userStore.create(data, callback)

  findById: (id, callback) ->
    userStore.findById(id, callback)

  findByCredentials: (login, password, callback) ->
    userStore.findByCredentials(login, password, callback)
