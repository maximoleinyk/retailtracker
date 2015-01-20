define (require) ->
  'use strict'

  Model = require('app/common/model')

  class Settings extends Model

    changeProfileSettings: ->
      @promise('post', '/settings/change/profile', @toJSON())

    changeSecuritySettings: ->
      @promise('post', '/settings/change/security', @toJSON())
