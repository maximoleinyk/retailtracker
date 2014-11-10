define (require) ->
  'use strict'

  Marionette = require('marionette')
  CompanyInviteConfirmed = require('cs!./confirmed')

  Marionette.ItemView.extend

    template: require('hbs!./confirm')

    templateHelpers: ->
      {
        company: @options.company
      }

    confirm: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.confirmCompanyInvite()
      .then =>
        @eventBus.trigger('open:page', new CompanyInviteConfirmed({
          company: @options.company
        }))
      .then null, (err) =>
        @validation.show(err.errors)
