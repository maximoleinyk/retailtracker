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
        window.location.replace('/page/' + (context.get('lastAuthUrl') or 'brand'))
      .then null, (err) =>
        @validation.show(err.errors)

      @model.unset('password')
