define (require) ->
  'use strict'

  ItemView = require('cs!app/common/marionette/itemView')
  CompanyInviteConfirmed = require('cs!./confirmed')

  ItemView.extend

    template: require('hbs!./main.hbs')
    className: 'page page-box'

    templateHelpers: ->
      company: @options.company.toJSON()
      userHasAccount: @options.company.get('hasAccount')

    confirm: (e) ->
      e.preventDefault()
      @validation.reset()

      @model.confirmCompanyInvite()
      .then =>
        @eventBus.trigger('open:page', new CompanyInviteConfirmed({
          company: @options.company
        }))
      .catch (err) =>
        @validation.show(err.errors)
