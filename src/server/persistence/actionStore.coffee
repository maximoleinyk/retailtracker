Action = inject('persistence/model/action')

module.exports = {

  create: (data, callback) ->
    invite = new Action(data)
    invite.save(callback)

}
