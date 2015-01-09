define (require) ->
  'use strict'

  Security = require('cs!app/account/models/security')
  ItemView = require('cs!app/common/marionette/itemView')
  context = require('cs!app/common/context')

  ItemView.extend

    template: require('hbs!./login.hbs')
    className: 'page page-box'

    initialize: ->
      @model = new Security()

    login: (e) ->
      e.preventDefault();
      @validation.reset()

      this.model.login()
      .then =>
        lastPath = context.get('lastAuthUrl')

        if (lastPath)
          module = lastPath.split('/')[0]

        if (lastPath and module)
          path = lastPath.replace(module, '')

        if (path)
          path = if path.indexOf('/') is 0 then path.substring(1) else path

        @eventBus.trigger('module:load', module or 'brand', path)
      .catch (err) =>
        @validation.show(err.errors)

      @model.unset('password')
