module.exports = AccountService

class AccountService

  constructor: (@userService) ->

  register: (email, firstName, callback) ->

  approve: (email, link, callback) ->

  changePassword: (email, oldPassword, newPassword, callback) ->

  changeForgottenPassword: (email, link, newPassword, callback) ->
