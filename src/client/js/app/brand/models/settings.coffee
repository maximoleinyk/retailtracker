define (require) ->
  'use strict'

  MongoModel = require('app/common/mongoModel')

  class Settings extends MongoModel

    changeProfileSettings: ->
      @promise('post', '/settings/change/profile', @toJSON())

    changeSecuritySettings: ->
      @promise('post', '/settings/change/security', @toJSON())