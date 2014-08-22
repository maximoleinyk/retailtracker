_ = require('underscore')
userService = inject('services/userService')

module.exports =
{
  changePassword: (data, callback) ->
    oldPassword = data.oldPassword
    password = data.password
    confirmPassword = data.confirmPassword

    errors = {}
    errors.generic = 'Идентификатор не найден' if not data.id
    errors.oldPassword = '' if not oldPassword
    errors.password = '' if not password
    errors.confirmPassword = '' if not confirmPassword
    errors.generic = 'Пароли не совпадают' if password and confirmPassword and password isnt confirmPassword

    return callback(errors) if not _.isEmpty(errors)

    userService.findById data.id, (err, user) ->
      return console.log(err) if err

      encryptedPass = userService.encryptPassword(oldPassword)

      return callback({ generic: 'Такой учетной записи не сущетвует' }) if not user
      return callback({ oldPassword: 'Текущай пароль не совпадает' }) if encryptedPass isnt user.password

      userService.update { password: encryptedPass }, (err) ->
        return console.log(err) if err
        callback(null, user)

  changeProfile: (data, callback) ->
    return callback({ generic: 'Идентификатор не найден' }) if not data.id
    return callback({ firstName: 'Имя должно быть указано' }) if not data.firstName

    userService.findById data.id, (err, user) ->
      return console.log(err) if err
      return callback({ generic: 'Такой учетной записи не сущетвует' }) if not user

      details =
        firstName: data.firstName
        lastName: data.lastName

      userService.update(details, callback)
}