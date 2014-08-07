userStore = inject('persistence/userStore')

module.exports =

    findById: (id, callback) ->
      userStore.findById(id, callback)
