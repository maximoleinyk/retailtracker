define (require) ->
  'use strict'

  Security = require('cs!app/account/models/security')
  Marionette = require('marionette')
  context = require('cs!app/common/context')
  moment = require('moment')

  Marionette.ItemView.extend

    template: require('hbs!./login.hbs')
    className: 'page page-box'

    initialize: ->
      @model = new Security()

    templateHelpers: ->
      year: moment().format('YYYY')

    login: (e) ->
      e.preventDefault();
      @validation.reset()

      this.model.login()
      .then =>
        module = context.get('lastAuthUrl').split('/')[0]
        path = context.get('lastAuthUrl').replace(module, '')
        path = if path.indexOf('/') is 0 then path.substring(1) else path
        @eventBus.trigger('module:load', module or 'brand', path)
      .then null, (err) =>
        @validation.show(err.errors)

      @model.unset('password')
