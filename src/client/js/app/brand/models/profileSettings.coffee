define (require) ->
  'use strict'

  Model = require('app/common/model')
  i18n = require('cs!app/common/i18n')

  class ProfileSettings extends Model

    urlRoot: '/settings/profile'

    validators:
      firstName:
        exists: true
        description: ->
          i18n.get('firstNameIsRequired')
