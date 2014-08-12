define (require) ->
  'use strict'

  Promise = require('rsvp').Promise
  http = require('util/http')
  Backbone = require('backbone')
  Marionette = require('marionette')
  sessionStore = require('util/sessionStore')

  Marionette.ItemView.extend

    template: require('hbs!./login')
    binding: true

    initialize: ->
      @model = new Backbone.Model()

    events:
      'submit': 'login'

    login: (e) ->
      e.preventDefault();

      @validation.reset @

      authenticate = new Promise (resolve, reject) =>
        http.post '/security/login', @model.toJSON(), resolve, ->
          reject('Invalid username/password.')

      authenticate
      .then =>
        redirectUrl = sessionStore.get('redirectUrl') or ''
        @eventBus.trigger('router:navigate', redirectUrl, {trigger: true})
        sessionStore.remove('redirectUrl')
      .then null, (err) =>
        if err.status is 403
          @validation.show({ generic: 'Учетная запись не существует' }, @)
        else
          @validation.show({ generic: err.statusText }, @)

      @model.unset('password')
