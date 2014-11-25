define (require) ->
  'use strict'

  MongoModel = require('cs!app/common/mongoModel')
  context = require('cs!app/common/context')

  class Activity extends MongoModel

    actions:
      'ACCOUNT_REGISTERED': (json) ->
        if context.isYou(json.user)
          json.action = window.RetailTracker.i18n.youHaveRegisteredAccount
        else
          json.action = window.RetailTracker.i18n.userHasRegisteredAccount
        return json

      'EMPLOYEE_INVITED_INTO_COMPANY': (json) ->
        json.action = window.RetailTracker.i18n.userInvitedIntoCompany + ' "<strong>' + json.company.name + '</strong>"'
        return json

      'EMPLOYEE_CONFIRMED_COMPANY_INVITE': (json) ->
        if context.isYou(json.user)
          json.action = window.RetailTracker.i18n.youConfirmedInviteToCompany + ' "<strong>' + json.company.name + '</strong>"'
        else
          json.action = window.RetailTracker.i18n.userConfirmedInviteToCompany + ' "<strong>' + json.company.name + '</strong>"'
        return json

      'EMPLOYEE_WAS_REMOVED_FROM_COMPANY': (json) ->
        json.action = window.RetailTracker.i18n.userWasRemovedFromCompany + ' "<strong>' + json.company.name + '</strong>"'
        return json

    parse: (json) ->
      json.user.id = json.user._id
      delete json.user._id
      formatter = @actions[json.action]
      if formatter then formatter(json) else json
