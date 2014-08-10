define (require) ->
  'use strict'

  Promise = require('rsvp').Promise
  http = require('util/http')
  Backbone = require('backbone')
  Marionette = require('marionette')

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
          @ensureHistory()
          @eventBus.trigger('router:reload')
        .then null, (err) =>
          if err.status is 403
            @validation.show({ generic: 'Учетная запись не существует' }, @)
          else
            @validation.show({ generic: err.statusText }, @)

      @model.unset('password')

    ensureHistory: ->
      return if Backbone.History.started

      Backbone.history.start
        pushState: true
        root: '/ui/'
        silent: true
