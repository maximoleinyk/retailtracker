define (require) ->
  'use strict'

  http = require('util/http')
  Marionette = require('marionette')

  Marionette.ItemView.extend
    template: require('hbs!./approve')
    binding: true

    ui:
      approveButton: '[type="submit"]'

    events:
      'submit': 'approve'

    approve: (e) ->
      e.preventDefault()

      @validation.reset()
      @ui.approveButton.attr('disabled', true)

      register = new Promise (resolve, reject) =>
        http.post '/security/approve', @model.toJSON(), resolve, reject

      register
      .then =>
        @eventBus.trigger('router:navigate', 'account/login', {trigger: true})
      .then null, (err) =>
        @validation.show(err.errors)
        @ui.approveButton.removeAttr('disabled')

