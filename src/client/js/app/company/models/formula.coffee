define (require) ->
  'use strict'

  Model = require('cs!app/common/model')
  i18n = require('cs!app/common/i18n')

  class Formula extends Model

    urlRoot: '/formula'

    defaults: ->
      columns: []
      status: 'DRAFT'

    validators:
      name:
        exists: true
        description: ->
          i18n.get('nameIsRequired')
      columns:
        minLength: 2
        description: ->
          i18n.get('addAnotherColumn')

    isActivated: ->
      @get('status') is 'ACTIVATED'

    activate: ->
      @save(null, {
        url: '/formula/' + this.id + '/activate'
      })
