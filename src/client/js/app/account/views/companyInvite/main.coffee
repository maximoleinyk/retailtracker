define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  CompanyInviteConfirmed = require('cs!./confirmed')

  ItemView.extend

    template: require('hbs!./main.hbs')
    className: 'page page-box'

    templateHelpers: ->
      company: @options.company.toJSON()

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
